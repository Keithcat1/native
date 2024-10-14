// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unused_import

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

class Bindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  Bindings(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  Bindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  Enum1 funcWithEnum1(
    Enum1 value,
  ) {
    return Enum1.fromValue(_funcWithEnum1(
      value.value,
    ));
  }

  late final _funcWithEnum1Ptr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int)>>('funcWithEnum1');
  late final _funcWithEnum1 = _funcWithEnum1Ptr.asFunction<int Function(int)>();

  int funcWithEnum2(
    int value,
  ) {
    return _funcWithEnum2(
      value,
    );
  }

  late final _funcWithEnum2Ptr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int)>>('funcWithEnum2');
  late final _funcWithEnum2 = _funcWithEnum2Ptr.asFunction<int Function(int)>();

  void funcWithBothEnums(
    Enum1 value1,
    int value2,
  ) {
    return _funcWithBothEnums(
      value1.value,
      value2,
    );
  }

  late final _funcWithBothEnumsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int, ffi.Int)>>(
          'funcWithBothEnums');
  late final _funcWithBothEnums =
      _funcWithBothEnumsPtr.asFunction<void Function(int, int)>();

  StructWithEnums funcWithStruct(
    StructWithEnums value,
  ) {
    return _funcWithStruct(
      value,
    );
  }

  late final _funcWithStructPtr =
      _lookup<ffi.NativeFunction<StructWithEnums Function(StructWithEnums)>>(
          'funcWithStruct');
  late final _funcWithStruct = _funcWithStructPtr
      .asFunction<StructWithEnums Function(StructWithEnums)>();
}

enum Enum1 {
  a(0),
  b(1),
  c(2);

  final int value;
  const Enum1(this.value);

  static Enum1 fromValue(int value) => switch (value) {
        0 => a,
        1 => b,
        2 => c,
        _ => throw ArgumentError("Unknown value for Enum1: $value"),
      };
}

sealed class Enum2 {
  static const value1 = 0;
  static const value2 = 1;
  static const value3 = 2;
}

final class StructWithEnums extends ffi.Struct {
  @ffi.Int()
  external int enum1AsInt;

  Enum1 get enum1 => Enum1.fromValue(enum1AsInt);

  @ffi.Int()
  external int enum2;
}
