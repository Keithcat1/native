// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
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

  late final ffi.Pointer<ffi.Int32> _test1 = _lookup<ffi.Int32>('test1');

  int get test1 => _test1.value;

  set test1(int value) => _test1.value = value;

  late final ffi.Pointer<ffi.Pointer<ffi.Float>> _test2 =
      _lookup<ffi.Pointer<ffi.Float>>('test2');

  ffi.Pointer<ffi.Float> get test2 => _test2.value;

  set test2(ffi.Pointer<ffi.Float> value) => _test2.value = value;

  late final ffi.Pointer<ffi.Pointer<Some>> _test5 =
      _lookup<ffi.Pointer<Some>>('test5');

  ffi.Pointer<Some> get test5 => _test5.value;

  set test5(ffi.Pointer<Some> value) => _test5.value = value;

  late final ffi.Pointer<EmptyStruct> _globalStruct =
      _lookup<EmptyStruct>('globalStruct');

  ffi.Pointer<EmptyStruct> get globalStruct => _globalStruct;
}

class Some extends ffi.Opaque {}

class EmptyStruct extends ffi.Opaque {}
