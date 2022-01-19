// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoredScript _$StoredScriptFromJson(Map json) => $checkedCreate(
      'StoredScript',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'uuid',
            'name',
            'command',
            'args',
            'workingDirectory',
            'runInDocker',
            'envVars'
          ],
          requiredKeys: const [
            'uuid',
            'name',
            'command',
            'args',
            'workingDirectory',
            'runInDocker',
            'envVars'
          ],
        );
        final val = StoredScript(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          command: $checkedConvert('command', (v) => v as String),
          args: $checkedConvert('args',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          workingDirectory:
              $checkedConvert('workingDirectory', (v) => v as String),
          runInDocker: $checkedConvert('runInDocker', (v) => v as bool),
          envVars: $checkedConvert(
              'envVars',
              (v) => (v as List<dynamic>)
                  .map((e) => StringPair.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$StoredScriptToJson(StoredScript instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'command': instance.command,
      'args': instance.args,
      'workingDirectory': instance.workingDirectory,
      'runInDocker': instance.runInDocker,
      'envVars': instance.envVars,
    };
