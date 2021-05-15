library raw_json;

import 'dart:convert' as convert;
import 'dart:core';

import 'package:flutter/foundation.dart';

@immutable
class RawJson {
  const RawJson.empty() : this._(const <dynamic, dynamic>{});

  RawJson.fromString(String anyString) : this._(safeDecode(anyString));

  RawJson.fromAny(dynamic any) : this._(any is Map<dynamic, dynamic> ? Map<String, dynamic>.from(any) : any);

  const RawJson._(this._any);

  RawJson operator [](String key) => RawJson.fromAny(_any is Map<String, dynamic> ? _any[key] : <String, dynamic>{});

  final dynamic _any;

  bool get available {
    final Map<String, dynamic>? map = cast(_any);
    if (map != null) {
      return map.isNotEmpty;
    } else {
      return _any != null;
    }
  }

  Iterable<RawJson> rawJsonCollection() {
    if (_any is List) {
      return (_any as List).map((dynamic item) => RawJson.fromAny(item));
    } else {
      return [];
    }
  }

  T value<T>() => _JsonValue(_any).value<T>();

  String encodeToString() => convert.jsonEncode(_any);
}

class _JsonValue {
  _JsonValue(this._any);

  final dynamic _any;

  T value<T>() {
    if (_any is T || (_any is Map && isTypeOf<T, Map<dynamic, dynamic>>())) {
      return _any as T;
    } else if (_any is num && isTypeOf<T, num>()) {
      if (isTypeOf<T, int>()) {
        return (_any as num).toInt() as T;
      } else if (isTypeOf<T, double>()) {
        return (_any as num).toDouble() as T;
      }
      return _any as T;
    } else if (_any is List<dynamic>) {
      if (isTypeOf<T, List<String>>()) {
        return List<String>.from(_any as Iterable<dynamic>) as T;
      } else {
        return _defaultValue<T>();
      }
    } else {
      return _defaultValue<T>();
    }
  }

  T _defaultValue<T>() {
    if (isTypeOf<T, int>()) return 0 as T;
    if (isTypeOf<T, double>()) return 0.0 as T;
    if (isTypeOf<T, bool>()) return false as T;
    if (isTypeOf<T, String>()) return '' as T;
    if (isTypeOf<T, List<String>>()) return <String>[] as T;
    if (isTypeOf<T, Map<String, dynamic>>()) return <String, dynamic>{} as T;
    if (isTypeOf<T, Map<dynamic, dynamic>>()) return <dynamic, dynamic>{} as T;

    throw FallThroughError();
  }
}

bool isTypeOf<ThisType, OfType>() => _Instance<ThisType>() is _Instance<OfType>;

class _Instance<T> {}

T? cast<T>(dynamic any) => any is T ? any : null;

dynamic safeDecode(String anyString) {
  try {
    return convert.jsonDecode(anyString);
  } on Exception catch (_) {
    return const <String, dynamic>{};
  }
}
