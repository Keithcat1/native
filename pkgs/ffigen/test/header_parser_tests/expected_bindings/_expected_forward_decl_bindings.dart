// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Forward Declaration Test
class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void func(
    ffi.Pointer<A> a,
    int b,
  ) {
    return _func(
      a,
      b,
    );
  }

  late final _funcPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<A>, ffi.Int32)>>(
          'func');
  late final _func = _funcPtr.asFunction<void Function(ffi.Pointer<A>, int)>();
}

class A extends ffi.Struct {
  @ffi.Int()
  external int a;

  @ffi.Int()
  external int b;
}

abstract class B {
  static const int a = 0;
  static const int b = 1;
}
