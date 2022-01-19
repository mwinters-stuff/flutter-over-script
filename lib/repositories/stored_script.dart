import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overscript/repositories/stored_string_pair.dart';
import 'package:uuid/uuid.dart';

part 'stored_script.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class StoredScript extends Equatable {
  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String command;
  @JsonKey(required: true)
  final List<String> args;
  @JsonKey(required: true)
  final String workingDirectory;
  @JsonKey(required: true)
  final bool runInDocker;
  @JsonKey(required: true)
  final List<StringPair> envVars;

  StoredScript.empty()
      : uuid = const Uuid().v1(),
        name = '',
        command = '',
        args = [],
        workingDirectory = '',
        runInDocker = false,
        envVars = [];

  const StoredScript({required this.uuid, required this.name, required this.command, required this.args, required this.workingDirectory, required this.runInDocker, required this.envVars});

  factory StoredScript.fromJson(Map json) => _$StoredScriptFromJson(json);

  Map<String, dynamic> toJson() => _$StoredScriptToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, name, command, args, workingDirectory, runInDocker, envVars];
}
