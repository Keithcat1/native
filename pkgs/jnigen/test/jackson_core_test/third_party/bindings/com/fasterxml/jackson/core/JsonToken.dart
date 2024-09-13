// Generated from jackson-core which is licensed under the Apache License 2.0.
// The following copyright from the original authors applies.
// See https://github.com/FasterXML/jackson-core/blob/2.14/LICENSE
//
// Copyright (c) 2007 - The Jackson Project Authors
// Licensed under the Apache License, Version 2.0 (the "License")
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Autogenerated by jnigen. DO NOT EDIT!

// ignore_for_file: annotate_overrides
// ignore_for_file: argument_type_not_assignable
// ignore_for_file: camel_case_extensions
// ignore_for_file: camel_case_types
// ignore_for_file: constant_identifier_names
// ignore_for_file: doc_directive_unknown
// ignore_for_file: file_names
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: only_throw_errors
// ignore_for_file: overridden_fields
// ignore_for_file: prefer_double_quotes
// ignore_for_file: unnecessary_cast
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: unused_element
// ignore_for_file: unused_field
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: unused_shown_name
// ignore_for_file: use_super_parameters

import 'dart:ffi' as ffi;
import 'dart:isolate' show ReceivePort;

import 'package:jni/internal_helpers_for_jnigen.dart';
import 'package:jni/jni.dart' as jni;

/// from: `com.fasterxml.jackson.core.JsonToken`
///
/// Enumeration for basic token types used for returning results
/// of parsing JSON content.
class JsonToken extends jni.JObject {
  @override
  late final jni.JObjType<JsonToken> $type = type;

  JsonToken.fromReference(
    jni.JReference reference,
  ) : super.fromReference(reference);

  static final _class =
      jni.JClass.forName(r'com/fasterxml/jackson/core/JsonToken');

  /// The type which includes information such as the signature of this class.
  static const type = $JsonTokenType();
  static final _id_values = _class.staticMethodId(
    r'values',
    r'()[Lcom/fasterxml/jackson/core/JsonToken;',
  );

  static final _values = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallStaticObjectMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `static public com.fasterxml.jackson.core.JsonToken[] values()`
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JArray<JsonToken> values() {
    return _values(_class.reference.pointer, _id_values as jni.JMethodIDPtr)
        .object(const jni.JArrayType($JsonTokenType()));
  }

  static final _id_valueOf = _class.staticMethodId(
    r'valueOf',
    r'(Ljava/lang/String;)Lcom/fasterxml/jackson/core/JsonToken;',
  );

  static final _valueOf = ProtectedJniExtensions.lookup<
              ffi.NativeFunction<
                  jni.JniResult Function(
                      ffi.Pointer<ffi.Void>,
                      jni.JMethodIDPtr,
                      ffi.VarArgs<(ffi.Pointer<ffi.Void>,)>)>>(
          'globalEnv_CallStaticObjectMethod')
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, jni.JMethodIDPtr,
              ffi.Pointer<ffi.Void>)>();

  /// from: `static public com.fasterxml.jackson.core.JsonToken valueOf(java.lang.String name)`
  /// The returned object must be released after use, by calling the [release] method.
  static JsonToken valueOf(
    jni.JString name,
  ) {
    return _valueOf(_class.reference.pointer, _id_valueOf as jni.JMethodIDPtr,
            name.reference.pointer)
        .object(const $JsonTokenType());
  }

  static final _id_id = _class.instanceMethodId(
    r'id',
    r'()I',
  );

  static final _id = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallIntMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final int id()`
  int id() {
    return _id(reference.pointer, _id_id as jni.JMethodIDPtr).integer;
  }

  static final _id_asString = _class.instanceMethodId(
    r'asString',
    r'()Ljava/lang/String;',
  );

  static final _asString = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallObjectMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final java.lang.String asString()`
  /// The returned object must be released after use, by calling the [release] method.
  jni.JString asString() {
    return _asString(reference.pointer, _id_asString as jni.JMethodIDPtr)
        .object(const jni.JStringType());
  }

  static final _id_asCharArray = _class.instanceMethodId(
    r'asCharArray',
    r'()[C',
  );

  static final _asCharArray = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallObjectMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final char[] asCharArray()`
  /// The returned object must be released after use, by calling the [release] method.
  jni.JArray<jni.jchar> asCharArray() {
    return _asCharArray(reference.pointer, _id_asCharArray as jni.JMethodIDPtr)
        .object(const jni.JArrayType(jni.jcharType()));
  }

  static final _id_asByteArray = _class.instanceMethodId(
    r'asByteArray',
    r'()[B',
  );

  static final _asByteArray = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallObjectMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final byte[] asByteArray()`
  /// The returned object must be released after use, by calling the [release] method.
  jni.JArray<jni.jbyte> asByteArray() {
    return _asByteArray(reference.pointer, _id_asByteArray as jni.JMethodIDPtr)
        .object(const jni.JArrayType(jni.jbyteType()));
  }

  static final _id_isNumeric = _class.instanceMethodId(
    r'isNumeric',
    r'()Z',
  );

  static final _isNumeric = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallBooleanMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final boolean isNumeric()`
  ///
  /// @return {@code True} if this token is {@code VALUE_NUMBER_INT} or {@code VALUE_NUMBER_FLOAT},
  ///   {@code false} otherwise
  bool isNumeric() {
    return _isNumeric(reference.pointer, _id_isNumeric as jni.JMethodIDPtr)
        .boolean;
  }

  static final _id_isStructStart = _class.instanceMethodId(
    r'isStructStart',
    r'()Z',
  );

  static final _isStructStart = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallBooleanMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final boolean isStructStart()`
  ///
  /// Accessor that is functionally equivalent to:
  /// <code>
  ///    this == JsonToken.START_OBJECT || this == JsonToken.START_ARRAY
  /// </code>
  ///@return {@code True} if this token is {@code START_OBJECT} or {@code START_ARRAY},
  ///   {@code false} otherwise
  ///@since 2.3
  bool isStructStart() {
    return _isStructStart(
            reference.pointer, _id_isStructStart as jni.JMethodIDPtr)
        .boolean;
  }

  static final _id_isStructEnd = _class.instanceMethodId(
    r'isStructEnd',
    r'()Z',
  );

  static final _isStructEnd = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallBooleanMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final boolean isStructEnd()`
  ///
  /// Accessor that is functionally equivalent to:
  /// <code>
  ///    this == JsonToken.END_OBJECT || this == JsonToken.END_ARRAY
  /// </code>
  ///@return {@code True} if this token is {@code END_OBJECT} or {@code END_ARRAY},
  ///   {@code false} otherwise
  ///@since 2.3
  bool isStructEnd() {
    return _isStructEnd(reference.pointer, _id_isStructEnd as jni.JMethodIDPtr)
        .boolean;
  }

  static final _id_isScalarValue = _class.instanceMethodId(
    r'isScalarValue',
    r'()Z',
  );

  static final _isScalarValue = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallBooleanMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final boolean isScalarValue()`
  ///
  /// Method that can be used to check whether this token represents
  /// a valid non-structured value. This means all {@code VALUE_xxx} tokens;
  /// excluding {@code START_xxx} and {@code END_xxx} tokens as well
  /// {@code FIELD_NAME}.
  ///@return {@code True} if this token is a scalar value token (one of
  ///   {@code VALUE_xxx} tokens), {@code false} otherwise
  bool isScalarValue() {
    return _isScalarValue(
            reference.pointer, _id_isScalarValue as jni.JMethodIDPtr)
        .boolean;
  }

  static final _id_isBoolean = _class.instanceMethodId(
    r'isBoolean',
    r'()Z',
  );

  static final _isBoolean = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>('globalEnv_CallBooleanMethod')
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: `public final boolean isBoolean()`
  ///
  /// @return {@code True} if this token is {@code VALUE_TRUE} or {@code VALUE_FALSE},
  ///   {@code false} otherwise
  bool isBoolean() {
    return _isBoolean(reference.pointer, _id_isBoolean as jni.JMethodIDPtr)
        .boolean;
  }
}

final class $JsonTokenType extends jni.JObjType<JsonToken> {
  const $JsonTokenType();

  @override
  String get signature => r'Lcom/fasterxml/jackson/core/JsonToken;';

  @override
  JsonToken fromReference(jni.JReference reference) =>
      JsonToken.fromReference(reference);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($JsonTokenType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($JsonTokenType) && other is $JsonTokenType;
  }
}
