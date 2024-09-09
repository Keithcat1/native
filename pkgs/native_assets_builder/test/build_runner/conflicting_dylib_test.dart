// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:native_assets_cli/native_assets_cli_internal.dart';
import 'package:test/test.dart';

import '../helpers.dart';
import 'helpers.dart';

const Timeout longTimeout = Timeout(Duration(minutes: 5));

void main() async {
  test('conflicting dylib name', timeout: longTimeout, () async {
    await inTempDir((tempUri) async {
      await copyTestProjects(targetUri: tempUri);
      final packageUri = tempUri.resolve('native_add_duplicate/');

      await runPubGet(
        workingDirectory: packageUri,
        logger: logger,
      );

      {
        final logMessages = <String>[];
        final result = await build(
          packageUri,
          createCapturingLogger(logMessages, level: Level.SEVERE),
          dartExecutable,
        );
        final fullLog = logMessages.join('\n');
        expect(result.success, false);
        expect(
          fullLog,
          contains('Duplicate dynamic library file name'),
        );
      }
    });
  });

  test('conflicting dylib name between link and build', timeout: longTimeout,
      () async {
    await inTempDir((tempUri) async {
      await copyTestProjects(targetUri: tempUri);
      final packageUri = tempUri.resolve('native_add_duplicate/');

      await runPubGet(
        workingDirectory: packageUri,
        logger: logger,
      );

      final buildResult = await build(
        packageUri,
        logger,
        linkingEnabled: true,
        dartExecutable,
      );
      expect(buildResult.success, isTrue);

      final linkResult = await link(
        packageUri,
        logger,
        dartExecutable,
        buildResult: buildResult,
      );
      expect(linkResult.success, isTrue);

      final allAssets = [...buildResult.assets, ...linkResult.assets];
      final validateResult = validateNoDuplicateDylibs(allAssets);
      expect(validateResult, isNotEmpty);
    });
  });
}