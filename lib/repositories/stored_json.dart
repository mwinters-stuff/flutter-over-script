import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overscript/repositories/repositories.dart';

part 'stored_json.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class StoredJson extends Equatable {
  @JsonKey(required: true)
  final List<StoredScript> scripts;
  final List<StoredVariable> variables;
  final List<StoredBranch> branches;

  factory StoredJson.fromJson(Map json) => _$StoredJsonFromJson(json);

  const StoredJson.empty()
      : scripts = const [],
        variables = const [],
        branches = const [];

  const StoredJson({required this.scripts, required this.variables, required this.branches});

  Map<String, dynamic> toJson() => _$StoredJsonToJson(this);

  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [scripts, variables, branches];
}
