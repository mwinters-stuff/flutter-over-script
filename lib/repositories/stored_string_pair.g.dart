// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_string_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringPair _$StringPairFromJson(Map json) => $checkedCreate(
      'StringPair',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['value1', 'value2'],
          requiredKeys: const ['value1', 'value2'],
        );
        final val = StringPair(
          $checkedConvert('value1', (v) => v as String),
          $checkedConvert('value2', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$StringPairToJson(StringPair instance) =>
    <String, dynamic>{
      'value1': instance.value1,
      'value2': instance.value2,
    };
