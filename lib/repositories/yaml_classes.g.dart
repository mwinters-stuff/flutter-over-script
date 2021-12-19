// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yaml_classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YamlTab _$YamlTabFromJson(Map json) => $checkedCreate(
      'YamlTab',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['title', 'options', 'docker-path', 'commands'],
          requiredKeys: const ['title'],
        );
        final val = YamlTab(
          title: $checkedConvert('title', (v) => v as String),
          commands: $checkedConvert('commands',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          options: $checkedConvert(
              'options',
              (v) => (v as Map?)?.map(
                    (k, e) =>
                        MapEntry(k as String, $enumDecode(_$optionEnumMap, e)),
                  )),
          dockerPath: $checkedConvert('docker-path', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'dockerPath': 'docker-path'},
    );

Map<String, dynamic> _$YamlTabToJson(YamlTab instance) => <String, dynamic>{
      'title': instance.title,
      'options':
          instance.options?.map((k, e) => MapEntry(k, _$optionEnumMap[e])),
      'docker-path': instance.dockerPath,
      'commands': instance.commands,
    };

const _$optionEnumMap = {
  option.yes: 'yes',
  option.no: 'no',
  option.both: 'both',
};

YamlScript _$YamlScriptFromJson(Map json) => $checkedCreate(
      'YamlScript',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['button', 'tabs'],
          requiredKeys: const ['button', 'tabs'],
        );
        final val = YamlScript(
          button: $checkedConvert('button', (v) => v as String),
          tabs: $checkedConvert(
              'tabs',
              (v) => (v as List<dynamic>)
                  .map((e) => YamlTab.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$YamlScriptToJson(YamlScript instance) =>
    <String, dynamic>{
      'button': instance.button,
      'tabs': instance.tabs,
    };

YamlScripts _$YamlScriptsFromJson(Map json) => $checkedCreate(
      'YamlScripts',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['scripts'],
          requiredKeys: const ['scripts'],
        );
        final val = YamlScripts(
          scripts: $checkedConvert(
              'scripts',
              (v) => (v as List<dynamic>)
                  .map((e) => YamlScript.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$YamlScriptsToJson(YamlScripts instance) =>
    <String, dynamic>{
      'scripts': instance.scripts,
    };
