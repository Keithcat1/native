// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:jnigen/jnigen.dart';
import 'package:jnigen/src/logging/logging.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

const testName = 'kotlin_test';
const jarFile = '$testName.jar';

final testRoot = join('test', testName);
final kotlinPath = join(testRoot, 'kotlin');
final jarPath = join(kotlinPath, 'target', jarFile);

const preamble = '''
// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

''';

void compileKotlinSources(String workingDir) async {
  final procRes = Process.runSync(
    'mvn',
    ['package'],
    workingDirectory: workingDir,
    runInShell: true,
  );
  if (procRes.exitCode != 0) {
    log.fatal('mvn exited with ${procRes.exitCode}\n'
        '${procRes.stderr}\n'
        '${procRes.stdout}');
  }
}

Config getConfig() {
  compileKotlinSources(kotlinPath);
  final dartWrappersRoot = Uri.directory(
    join(testRoot, 'bindings'),
  );
  final config = Config(
    classPath: [Uri.file(jarPath)],
    classes: [
      // Generating the entire library.
      //
      // This makes sure that no private class generated by Kotlin can make its
      // way to the generated code.
      'com.github.dart_lang.jnigen',
    ],
    logLevel: Level.ALL,
    outputConfig: OutputConfig(
      dartConfig: DartCodeOutputConfig(
        path: dartWrappersRoot.resolve('kotlin.dart'),
        structure: OutputStructure.singleFile,
      ),
    ),
    summarizerOptions: SummarizerOptions(backend: SummarizerBackend.asm),
    preamble: preamble,
  );
  return config;
}

void main() async {
  await generateJniBindings(getConfig());
}
