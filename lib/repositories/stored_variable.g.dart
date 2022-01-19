// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoredVariable _$StoredVariableFromJson(Map json) => $checkedCreate(
      'StoredVariable',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'name', 'branchValues'],
          requiredKeys: const ['uuid', 'name', 'branchValues'],
        );
        final val = StoredVariable(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          branchValues: $checkedConvert(
              'branchValues',
              (v) => (v as List<dynamic>)
                  .map((e) => StringPair.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$StoredVariableToJson(StoredVariable instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'branchValues': instance.branchValues,
    };
