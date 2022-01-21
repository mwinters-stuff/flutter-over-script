// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoredBranch _$StoredBranchFromJson(Map json) => $checkedCreate(
      'StoredBranch',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'name', 'directory'],
          requiredKeys: const ['uuid', 'name', 'directory'],
        );
        final val = StoredBranch(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          directory: $checkedConvert('directory', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$StoredBranchToJson(StoredBranch instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'directory': instance.directory,
    };
