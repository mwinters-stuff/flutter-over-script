// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoredJson _$StoredJsonFromJson(Map json) => $checkedCreate(
      'StoredJson',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['scripts', 'variables'],
          requiredKeys: const ['scripts'],
        );
        final val = StoredJson(
          scripts: $checkedConvert(
              'scripts',
              (v) => (v as List<dynamic>)
                  .map((e) => StoredScript.fromJson(e as Map))
                  .toList()),
          variables: $checkedConvert(
              'variables',
              (v) => (v as List<dynamic>)
                  .map((e) => StoredVariable.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$StoredJsonToJson(StoredJson instance) =>
    <String, dynamic>{
      'scripts': instance.scripts,
      'variables': instance.variables,
    };
