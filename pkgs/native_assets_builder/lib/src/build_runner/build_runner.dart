// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:package_config/package_config.dart';

import '../package_layout/package_layout.dart';
import '../utils/run_process.dart';
import 'build_planner.dart';

typedef DependencyMetadata = Map<String, Metadata>;

/// The programmatic API to be used by Dart launchers to invoke native builds.
///
/// These methods are invoked by launchers such as dartdev (for `dart run`)
/// and flutter_tools (for `flutter run` and `flutter build`).
class NativeAssetsRunner {
  final Logger logger;
  final Uri dartExecutable;

  NativeAssetsRunner({
    required this.logger,
    required this.dartExecutable,
  });

  /// [workingDirectory] is expected to contain `.dart_tool`.
  ///
  /// This method is invoked by launchers such as dartdev (for `dart run`) and
  /// flutter_tools (for `flutter run` and `flutter build`).
  ///
  /// If provided, only native assets of all transitive dependencies of
  /// [runPackageName] are built.
  Future<BuildResult> build({
    required LinkModePreference linkModePreference,
    required Target target,
    required Uri workingDirectory,
    required BuildMode buildMode,
    CCompilerConfig? cCompilerConfig,
    IOSSdk? targetIOSSdk,
    int? targetAndroidNdkApi,
    required bool includeParentEnvironment,
    PackageLayout? packageLayout,
    String? runPackageName,
  }) async =>
      _run(
        buildStep: const BuildStep(),
        linkModePreference: linkModePreference,
        target: target,
        workingDirectory: workingDirectory,
        buildMode: buildMode,
        cCompilerConfig: cCompilerConfig,
        targetIOSSdk: targetIOSSdk,
        targetAndroidNdkApi: targetAndroidNdkApi,
        includeParentEnvironment: includeParentEnvironment,
        packageLayout: packageLayout,
        runPackageName: runPackageName,
      );

  Future<BuildResult> link({
    required Target target,
    required Uri workingDirectory,
    required BuildMode buildMode,
    CCompilerConfig? cCompilerConfig,
    IOSSdk? targetIOSSdk,
    int? targetAndroidNdkApi,
    required bool includeParentEnvironment,
    PackageLayout? packageLayout,
    Uri? resourceIdentifiers,
    String? runPackageName,
  }) async =>
      _run(
        buildStep: const LinkStep(),
        linkModePreference: LinkModePreference.dynamic,
        target: target,
        workingDirectory: workingDirectory,
        buildMode: buildMode,
        cCompilerConfig: cCompilerConfig,
        targetIOSSdk: targetIOSSdk,
        targetAndroidNdkApi: targetAndroidNdkApi,
        includeParentEnvironment: includeParentEnvironment,
        packageLayout: packageLayout,
        runPackageName: runPackageName,
      );

  Future<BuildResult> _run({
    required RunStep buildStep,
    required LinkModePreference linkModePreference,
    required Target target,
    required Uri workingDirectory,
    required BuildMode buildMode,
    CCompilerConfig? cCompilerConfig,
    IOSSdk? targetIOSSdk,
    int? targetAndroidNdkApi,
    required bool includeParentEnvironment,
    PackageLayout? packageLayout,
    Uri? resourceIdentifiers,
    String? runPackageName,
  }) async {
    packageLayout ??= await PackageLayout.fromRootPackageRoot(workingDirectory);
    final packagesWithBuild =
        await packageLayout.packagesWithNativeAssets(buildStep);
    final (packages, dependencyGraph, planSuccess) = await _plannedPackages(
        packagesWithBuild, packageLayout, runPackageName);
    if (!planSuccess) {
      return BuildResult._(assets: [], dependencies: [], success: false);
    }
    final assets = <Asset>[];
    final dependencies = <Uri>[];
    final metadata = <String, Metadata>{};
    var success = true;
    for (final package in packages) {
      final dependencyMetadata = _metadataForPackage(
        dependencyGraph: dependencyGraph,
        packageName: package.name,
        targetMetadata: metadata,
      );
      final config = await _cliConfig(
        packageName: package.name,
        packageRoot: packageLayout.packageRoot(package.name),
        target: target,
        buildMode: buildMode,
        linkMode: linkModePreference,
        buildParentDir: packageLayout.dartToolNativeAssetsBuilder,
        dependencyMetadata: dependencyMetadata,
        cCompilerConfig: cCompilerConfig,
        targetIOSSdk: targetIOSSdk,
        targetAndroidNdkApi: targetAndroidNdkApi,
      );
      final (buildOutput, packageSuccess) = await _runPackageCached(
        buildStep,
        config,
        packageLayout.packageConfigUri,
        workingDirectory,
        includeParentEnvironment,
        resourceIdentifiers,
      );
      assets.addAll(buildOutput.assets);
      dependencies.addAll(buildOutput.dependencies.dependencies);
      success &= packageSuccess;
      metadata[config.packageName] = buildOutput.metadata;
    }
    return BuildResult._(
      assets: assets,
      dependencies: dependencies..sort(_uriCompare),
      success: success,
    );
  }

  /// [workingDirectory] is expected to contain `.dart_tool`.
  ///
  /// This method is invoked by launchers such as dartdev (for `dart run`) and
  /// flutter_tools (for `flutter run` and `flutter build`).
  ///
  /// If provided, only native assets of all transitive dependencies of
  /// [runPackageName] are built.
  Future<BuildResult> dryBuild({
    required LinkModePreference linkModePreference,
    required OS targetOs,
    required Uri workingDirectory,
    required bool includeParentEnvironment,
    PackageLayout? packageLayout,
    String? runPackageName,
  }) async {
    packageLayout ??= await PackageLayout.fromRootPackageRoot(workingDirectory);
    final packagesWithBuild = await packageLayout.packagesWithNativeBuild;
    final (packages, _, planSuccess) = await _plannedPackages(
      packagesWithBuild,
      packageLayout,
      runPackageName,
    );
    if (!planSuccess) {
      return BuildResult._(assets: [], dependencies: [], success: false);
    }
    final assets = <Asset>[];
    var success = true;
    for (final package in packages) {
      final config = await _cliConfigDryRun(
        packageName: package.name,
        packageRoot: packageLayout.packageRoot(package.name),
        targetOs: targetOs,
        linkMode: linkModePreference,
        buildParentDir: packageLayout.dartToolNativeAssetsBuilder,
      );
      final (buildOutput, packageSuccess) = await _buildPackage(
        const BuildStep(),
        config,
        packageLayout.packageConfigUri,
        workingDirectory,
        includeParentEnvironment,
        null,
      );
      assets.addAll(buildOutput.assets);
      success &= packageSuccess;
    }
    return BuildResult._dryrun(assets: assets, success: success);
  }

  Future<_PackageBuildRecord> _runPackageCached(
    RunStep runStep,
    BuildConfig config,
    Uri packageConfigUri,
    Uri workingDirectory,
    bool includeParentEnvironment,
    Uri? resources,
  ) async {
    final packageName = config.packageName;
    final outDir = config.outDir;
    if (!await Directory.fromUri(outDir).exists()) {
      await Directory.fromUri(outDir).create(recursive: true);
    }

    final buildOutput = await BuildOutput.readFromFile(
      outDir: outDir,
      step: runStep,
    );
    final lastBuilt = buildOutput?.timestamp.roundDownToSeconds() ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final dependencies = buildOutput?.dependencies;
    final lastChange = await dependencies?.lastModified() ?? DateTime.now();

    if (lastBuilt.isAfter(lastChange)) {
      logger.info('Skipping build for $packageName in $outDir. '
          'Last build on $lastBuilt, last input change on $lastChange.');
      // All build flags go into [outDir]. Therefore we do not have to check
      // here whether the config is equal.
      return (buildOutput!, true);
    }

    return await _buildPackage(
      runStep,
      config,
      packageConfigUri,
      workingDirectory,
      includeParentEnvironment,
      resources,
    );
  }

  Future<_PackageBuildRecord> _buildPackage(
    RunStep runStep,
    BuildConfig config,
    Uri packageConfigUri,
    Uri workingDirectory,
    bool includeParentEnvironment,
    Uri? resources,
  ) async {
    final outDir = config.outDir;
    final configFile = outDir.resolve('../config.yaml');
    final script = config.packageRoot.resolve(runStep.scriptName);
    final configFileContents = config.toYamlString();
    logger.info('config.yaml contents: $configFileContents');
    await File.fromUri(configFile).writeAsString(configFileContents);
    final buildOutputFile = File.fromUri(outDir.resolve(runStep.outputName));
    if (await buildOutputFile.exists()) {
      // Ensure we'll never read outdated build results.
      await buildOutputFile.delete();
    }
    final arguments = [
      '--packages=${packageConfigUri.toFilePath()}',
      script.toFilePath(),
      ...runStep.args(
        configFile,
        outDir.resolve(const BuildStep().outputName),
        resources,
      ),
    ];
    final result = await runProcess(
      workingDirectory: workingDirectory,
      executable: dartExecutable,
      arguments: arguments,
      logger: logger,
      includeParentEnvironment: includeParentEnvironment,
    );
    var success = true;
    if (result.exitCode != 0) {
      final printWorkingDir = workingDirectory != Directory.current.uri;
      final commandString = [
        if (printWorkingDir) '(cd ${workingDirectory.toFilePath()};',
        dartExecutable.toFilePath(),
        ...arguments.map((a) => a.contains(' ') ? "'$a'" : a),
        if (printWorkingDir) ')',
      ].join(' ');
      logger.severe(
        '''
Building native assets for package:${config.packageName} failed.
${runStep.scriptName} returned with exit code: ${result.exitCode}.
To reproduce run:
$commandString
stderr:
${result.stderr}
stdout:
${result.stdout}
        ''',
      );
      success = false;
    }

    try {
      final buildOutput = await BuildOutput.readFromFile(
        outDir: outDir,
        step: runStep,
      );
      success &=
          validateAssetsPackage(buildOutput?.assets ?? [], config.packageName);
      return (buildOutput ?? BuildOutput(), success);
    } on FormatException catch (e) {
      logger.severe('''
Building native assets for package:${config.packageName} failed.
build_output.yaml contained a format error.
${e.message}
        ''');
      success = false;
      return (BuildOutput(), false);
      // TODO(https://github.com/dart-lang/native/issues/109): Stop throwing
      // type errors in native_assets_cli, release a new version of that package
      // and then remove this.
      // ignore: avoid_catching_errors
    } on TypeError {
      logger.severe('''
Building native assets for package:${config.packageName} failed.
build_output.yaml contained a format error.
        ''');
      success = false;
      return (BuildOutput(), false);
    } finally {
      if (!success) {
        if (await buildOutputFile.exists()) {
          await buildOutputFile.delete();
        }
      }
    }
  }

  static Future<BuildConfig> _cliConfig({
    required String packageName,
    required Uri packageRoot,
    required Target target,
    IOSSdk? targetIOSSdk,
    int? targetAndroidNdkApi,
    required BuildMode buildMode,
    required LinkModePreference linkMode,
    required Uri buildParentDir,
    CCompilerConfig? cCompilerConfig,
    DependencyMetadata? dependencyMetadata,
  }) async {
    final buildDirName = BuildConfig.checksum(
      packageName: packageName,
      packageRoot: packageRoot,
      targetOs: target.os,
      targetArchitecture: target.architecture,
      buildMode: buildMode,
      linkModePreference: linkMode,
      targetIOSSdk: targetIOSSdk,
      cCompiler: cCompilerConfig,
      dependencyMetadata: dependencyMetadata,
      targetAndroidNdkApi: targetAndroidNdkApi,
    );
    final outDirUri = buildParentDir.resolve('$buildDirName/out/');
    final outDir = Directory.fromUri(outDirUri);
    if (!await outDir.exists()) {
      // TODO(https://dartbug.com/50565): Purge old or unused folders.
      await outDir.create(recursive: true);
    }
    return BuildConfig(
      outDir: outDirUri,
      packageName: packageName,
      packageRoot: packageRoot,
      targetOs: target.os,
      targetArchitecture: target.architecture,
      buildMode: buildMode,
      linkModePreference: linkMode,
      targetIOSSdk: targetIOSSdk,
      cCompiler: cCompilerConfig,
      dependencyMetadata: dependencyMetadata,
      targetAndroidNdkApi: targetAndroidNdkApi,
    );
  }

  static Future<BuildConfig> _cliConfigDryRun({
    required String packageName,
    required Uri packageRoot,
    required OS targetOs,
    required LinkModePreference linkMode,
    required Uri buildParentDir,
  }) async {
    final buildDirName = 'dry_run_${targetOs}_$linkMode';
    final outDirUri = buildParentDir.resolve('$buildDirName/out/');
    final outDir = Directory.fromUri(outDirUri);
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }
    return BuildConfig.dryRun(
      outDir: outDirUri,
      packageName: packageName,
      packageRoot: packageRoot,
      targetOs: targetOs,
      linkModePreference: linkMode,
    );
  }

  DependencyMetadata? _metadataForPackage({
    required DependencyGraph dependencyGraph,
    required String packageName,
    DependencyMetadata? targetMetadata,
  }) {
    if (targetMetadata == null) {
      return null;
    }
    final dependencies = dependencyGraph.neighborsOf(packageName).toSet();
    return {
      for (final entry in targetMetadata.entries)
        if (dependencies.contains(entry.key)) entry.key: entry.value,
    };
  }

  bool validateAssetsPackage(List<Asset> assets, String packageName) {
    final invalidAssetIds = assets
        .map((a) => a.id)
        .where((n) => !n.startsWith('package:$packageName/'))
        .toSet()
        .toList()
      ..sort();
    final success = invalidAssetIds.isEmpty;
    if (!success) {
      logger.severe(
        '`package:$packageName` declares the following assets which do not '
        'start with `package:$packageName/`: ${invalidAssetIds.join(', ')}.',
      );
    }
    return success;
  }

  Future<(List<Package> plan, DependencyGraph dependencyGraph, bool success)>
      _plannedPackages(
    List<Package> packagesWithNativeAssets,
    PackageLayout packageLayout,
    String? runPackageName,
  ) async {
    if (packagesWithNativeAssets.length <= 1 && runPackageName != null) {
      final dependencyGraph = DependencyGraph({
        for (final p in packagesWithNativeAssets) p.name: [],
      });
      return (packagesWithNativeAssets, dependencyGraph, true);
    } else {
      final planner = await NativeAssetsPlanner.fromRootPackageRoot(
        rootPackageRoot: packageLayout.rootPackageRoot,
        packagesWithNativeAssets: packagesWithNativeAssets,
        dartExecutable: Uri.file(Platform.resolvedExecutable),
        logger: logger,
      );
      final (plan, planSuccess) = planner.plan(
        runPackageName: runPackageName,
      );
      return (plan, planner.dependencyGraph, planSuccess);
    }
  }
}

typedef _PackageBuildRecord = (BuildOutput, bool success);

/// The result from a [NativeAssetsRunner._run].
final class BuildResult {
  /// All the files used for building the native assets of all packages.
  ///
  /// This aggregated list can be used to determine whether the
  /// [NativeAssetsRunner] needs to be invoked again. The
  /// [NativeAssetsRunner] determines per package with native assets
  /// if it needs to run the build again.
  final List<Uri> dependencies;

  final List<Asset> assets;

  final bool success;

  BuildResult._({
    required this.assets,
    required this.dependencies,
    required this.success,
  });

  BuildResult._dryrun({
    required this.assets,
    required this.success,
  }) : dependencies = [];
}

extension on DateTime {
  DateTime roundDownToSeconds() =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch -
          millisecondsSinceEpoch % const Duration(seconds: 1).inMilliseconds);
}

int _uriCompare(Uri u1, Uri u2) => u1.toString().compareTo(u2.toString());
