import 'package:json_annotation/json_annotation.dart';

part 'stored_script.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class StoredScript {
  @JsonKey(required: true)
  String uuid;
  @JsonKey(required: true)
  String name;
  @JsonKey(required: true)
  String command;
  @JsonKey(required: true)
  List<String> args;
  @JsonKey(required: true)
  String workingDirectory;
  @JsonKey(required: true)
  bool runInDocker;
  @JsonKey(required: true)
  Map<String, String> envVars;

  StoredScript.empty()
      : uuid = '',
        name = '',
        command = '',
        args = [],
        workingDirectory = '',
        runInDocker = false,
        envVars = {};

  StoredScript(
      {required this.uuid,
      required this.name,
      required this.command,
      required this.args,
      required this.workingDirectory,
      required this.runInDocker,
      required this.envVars});

  factory StoredScript.fromJson(Map json) => _$StoredScriptFromJson(json);

  Map<String, dynamic> toJson() => _$StoredScriptToJson(this);
  @override
  String toString() => '${toJson()}';
}

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class StoredScripts {
  @JsonKey(required: true)
  List<StoredScript> scripts = [];

  factory StoredScripts.fromJson(Map json) => _$StoredScriptsFromJson(json);

  StoredScripts();

  Map<String, dynamic> toJson() => _$StoredScriptsToJson(this);

  @override
  String toString() => '${toJson()}';
}
