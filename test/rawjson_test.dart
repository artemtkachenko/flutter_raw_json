import 'package:flutter_test/flutter_test.dart';
import 'package:rawjson/raw_json.dart';

const RawJson kEmptyJson = RawJson.empty();
final RawJson kEmptyJson1 = RawJson.fromString('');
final RawJson kEmptyJson2 = RawJson.fromString('any_string');
final RawJson kEmptyJson3 = RawJson.fromString(' ');
final RawJson kEmptyJson4 = RawJson.fromAny(const <dynamic>[]);
final RawJson kEmptyJson5 = RawJson.fromAny(const <dynamic, dynamic>{});
final RawJson kEmptyJson6 = RawJson.fromAny(const <String, dynamic>{});
final RawJson kEmptyJson7 = RawJson.fromAny(1);
final RawJson kEmptyJson8 = RawJson.fromAny(1.0);
final RawJson kEmptyJson9 = RawJson.fromAny(-1);
final RawJson kEmptyJson10 = RawJson.fromAny(false);
final RawJson kEmptyJson11 = RawJson.fromAny(true);

void main() {
  final emptyRawJsonCollection = [
    kEmptyJson,
    kEmptyJson1,
    kEmptyJson2,
    kEmptyJson3,
    kEmptyJson4,
    kEmptyJson5,
    kEmptyJson6,
    kEmptyJson7,
    kEmptyJson8,
    kEmptyJson9,
    kEmptyJson10,
    kEmptyJson11
  ];

  test('empty json should not contain any values', () {
    emptyRawJsonCollection
        .map((rawJson) => [
              rawJson[''],
              rawJson[' '],
              rawJson['\n'],
              rawJson['\n\r'],
              rawJson['null'],
              rawJson['empty'],
              rawJson['some_value'],
            ])
        .expand((e) => e)
        .forEach((rawJson) => expect(rawJson.available, false));
  });

  test('checking default values in empty json', () {
    emptyRawJsonCollection
        .map((rawJson) => [
              rawJson[''],
              rawJson[' '],
              rawJson['\n'],
              rawJson['\n\r'],
              rawJson['null'],
              rawJson['empty'],
              rawJson['some_value'],
            ])
        .expand((e) => e)
        .forEach((rawJson) {
      final int intValue = rawJson.value();
      final intValue1 = rawJson.value<int>();
      expect(intValue, 0);
      expect(intValue1, 0);

      final double doubleValue = rawJson.value();
      final doubleValue1 = rawJson.value<double>();
      expect(doubleValue, 0.0);
      expect(doubleValue1, 0.0);

      final bool boolValue = rawJson.value();
      final boolValue1 = rawJson.value<bool>();
      expect(boolValue, false);
      expect(boolValue1, false);

      final String stringValue = rawJson.value();
      final stringValue1 = rawJson.value<String>();
      expect(stringValue, '');
      expect(stringValue1, '');

      final List<String> stringList = rawJson.value();
      final stringList1 = rawJson.value<List<String>>();
      expect(stringList, <String>[]);
      expect(stringList1, <String>[]);

      final Map<dynamic, dynamic> dynamicMap = rawJson.value();
      final dynamicMap1 = rawJson.value<Map<dynamic, dynamic>>();
      expect(dynamicMap, <dynamic, dynamic>{});
      expect(dynamicMap1, <dynamic, dynamic>{});

      final Map<String, dynamic> stringDynamicMap = rawJson.value();
      final stringDynamicMap1 = rawJson.value<Map<String, dynamic>>();
      expect(stringDynamicMap, <String, dynamic>{});
      expect(stringDynamicMap1, <String, dynamic>{});
    });
  });
}
