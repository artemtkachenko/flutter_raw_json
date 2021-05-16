import 'package:flutter_test/flutter_test.dart';
import 'package:rawjson/raw_json.dart';

void main() {
  final jsonWithData = RawJson.fromAny(const {
    /* int */
    'positive_int_value': 1,
    'negative_int_value': -1,
    'null_int_value': null,
    /* double */
    'positive_double_value': 1.0,
    'negative_double_value': -1.0,
    'null_double_value': null,
    /* bool */
    'true_bool_value': true,
    'false_bool_value': false,
    'null_bool_value': null,
    /* string */
    'test_string': 'test string value',
    'null_test_string': null,
    /* collection of <String> */
    'string_collection': ['1', '2', '3'],
    'null_string_collection:': null,
    /* map */
    'test_map': {'int_key': 1, 'string_key': 'test string value'},
    'null_test_map': null,
    /* collection of Map<,> */
    'test_collection': [
      {'int_key': 1, 'string_key': 'test string value1'},
      {'int_key': 2, 'string_key': 'test string value2'}
    ],
    'null_test_collection': null,
  });
  testDeserialization([jsonWithData]);

  testDefaultValues([
    const RawJson.empty(),
    RawJson.fromString(''),
    RawJson.fromString('any_string'),
    RawJson.fromString(' '),
    RawJson.fromString('\n'),
    RawJson.fromAny(const <dynamic>[]),
    RawJson.fromAny(const <dynamic, dynamic>{}),
    RawJson.fromAny(const <String, dynamic>{}),
    RawJson.fromAny(1),
    RawJson.fromAny(1.0),
    RawJson.fromAny(-1),
    RawJson.fromAny(false),
    RawJson.fromAny(true),
    jsonWithData,
  ]);
}

void testDeserialization(List<RawJson> testCollection) {
  test('test deserialization implementation', () {
    testCollection.forEach((rawJson) {
      testType<int>(
        positiveValueRawJson: rawJson['positive_int_value'],
        expectedPositiveValue: 1,
        negativeValueRawJson: rawJson['negative_int_value'],
        expectedNegativeValue: -1,
        nullValueRawJson: rawJson['null_int_value'],
        expectedDefaultValue: 0,
      );

      testType<double>(
        positiveValueRawJson: rawJson['positive_double_value'],
        expectedPositiveValue: 1.0,
        negativeValueRawJson: rawJson['negative_double_value'],
        expectedNegativeValue: -1.0,
        nullValueRawJson: rawJson['null_double_value'],
        expectedDefaultValue: 0.0,
      );

      testType<bool>(
        positiveValueRawJson: rawJson['true_bool_value'],
        expectedPositiveValue: true,
        negativeValueRawJson: rawJson['false_bool_value'],
        expectedNegativeValue: false,
        nullValueRawJson: rawJson['null_bool_value'],
        expectedDefaultValue: false,
      );

      testType<String>(
        positiveValueRawJson: rawJson['test_string'],
        expectedPositiveValue: 'test string value',
        nullValueRawJson: rawJson['null_test_string'],
        expectedDefaultValue: '',
      );

      testType<List<String>>(
        positiveValueRawJson: rawJson['string_collection'],
        expectedPositiveValue: ['1', '2', '3'],
        nullValueRawJson: rawJson['null_string_collection'],
        expectedDefaultValue: [],
      );

      testType<Map<dynamic, dynamic>>(
        positiveValueRawJson: rawJson['test_map'],
        expectedPositiveValue: {'int_key': 1, 'string_key': 'test string value'},
        nullValueRawJson: rawJson['null_test_string'],
        expectedDefaultValue: <dynamic, dynamic>{},
      );

      final collectionRawJson = rawJson['test_collection'];
      final nullRawJson = rawJson['null_test_collection'];
      expect(collectionRawJson.available, true);
      expect(nullRawJson.available, false);

      expect(
        collectionRawJson.rawJsonCollection().map((e) => e.value<Map<dynamic, dynamic>>()),
        [
          RawJson.fromAny(const {'int_key': 1, 'string_key': 'test string value1'}),
          RawJson.fromAny(const {'int_key': 2, 'string_key': 'test string value2'})
        ].map((e) => e.value<Map<dynamic, dynamic>>()),
      );
      expect(nullRawJson.rawJsonCollection(), <RawJson>[]);
    });
  });
}

void testDefaultValues(List<RawJson> testCollection) {
  final rawJsonCollection = testCollection
      .map((rawJson) => [
            rawJson[''],
            rawJson[' '],
            rawJson['\n'],
            rawJson['\n\r'],
            rawJson['null'],
            rawJson['empty'],
            rawJson['some_value'],
          ])
      .expand((e) => e);

  test('empty json should not contain any values', () {
    rawJsonCollection.forEach((rawJson) => expect(rawJson.available, false));
  });

  test('checking default values in empty json', () {
    rawJsonCollection.forEach((rawJson) {
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

void testType<Type>({
  required RawJson positiveValueRawJson,
  required Type expectedPositiveValue,
  RawJson? negativeValueRawJson,
  Type? expectedNegativeValue,
  required RawJson nullValueRawJson,
  required Type expectedDefaultValue,
}) {
  expect(positiveValueRawJson.available, true);
  if (negativeValueRawJson != null) {
    expect(negativeValueRawJson.available, true);
  }
  expect(nullValueRawJson.available, false);

  final Type positiveValue = positiveValueRawJson.value();
  final intPositiveValue1 = positiveValueRawJson.value<Type>();
  expect(positiveValue, expectedPositiveValue);
  expect(intPositiveValue1, expectedPositiveValue);

  if (negativeValueRawJson != null) {
    final Type intNegativeValue = negativeValueRawJson.value();
    final intNegativeValue1 = negativeValueRawJson.value<Type>();
    expect(intNegativeValue, expectedNegativeValue);
    expect(intNegativeValue1, expectedNegativeValue);
  }

  final Type intNullValue = nullValueRawJson.value();
  final intNullValue1 = nullValueRawJson.value<Type>();
  expect(intNullValue, expectedDefaultValue);
  expect(intNullValue1, expectedDefaultValue);
}
