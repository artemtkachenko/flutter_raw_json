library raw_json;

import 'dart:convert' as convert;

class RawJson {
  const RawJson.empty() : this._(const <dynamic, dynamic>{});

  RawJson.fromString(String anyString) : this._(_safeDecode(anyString));

  RawJson.fromAny(dynamic any) : this._(any is Map<dynamic, dynamic> ? Map<String, dynamic>.from(any) : any);

  const RawJson._(this._any);

  RawJson operator [](String key) => RawJson.fromAny(_any is Map<String, dynamic> ? _any[key] : <String, dynamic>{});

  final dynamic _any;

  bool get available {
    final Map<String, dynamic>? map = _cast(_any);
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
    if (_any is T || (_any is Map && _isTypeOf<T, Map<dynamic, dynamic>>())) {
      return _any as T;
    } else if (_any is num && _isTypeOf<T, num>()) {
      if (_isTypeOf<T, int>()) {
        return (_any as num).toInt() as T;
      } else if (_isTypeOf<T, double>()) {
        return (_any as num).toDouble() as T;
      }
      return _any as T;
    } else if (_any is List<dynamic>) {
      if (_isTypeOf<T, List<String>>()) {
        return List<String>.from(_any as Iterable<dynamic>) as T;
      } else {
        return _defaultValue<T>();
      }
    } else {
      return _defaultValue<T>();
    }
  }

  T _defaultValue<T>() {
    if (_isTypeOf<T, int>()) return 0 as T;
    if (_isTypeOf<T, double>()) return 0.0 as T;
    if (_isTypeOf<T, bool>()) return false as T;
    if (_isTypeOf<T, String>()) return '' as T;
    if (_isTypeOf<T, List<String>>()) return <String>[] as T;
    if (_isTypeOf<T, Map<String, dynamic>>()) return <String, dynamic>{} as T;
    if (_isTypeOf<T, Map<dynamic, dynamic>>()) return <dynamic, dynamic>{} as T;

    throw FallThroughError();
  }
}

bool _isTypeOf<ThisType, OfType>() => _Instance<ThisType>() is _Instance<OfType>;

class _Instance<T> {}

T? _cast<T>(dynamic any) => any is T ? any : null;

dynamic _safeDecode(String anyString) {
  try {
    return convert.jsonDecode(anyString);
  } on Exception catch (_) {
    return const <String, dynamic>{};
  }
}
