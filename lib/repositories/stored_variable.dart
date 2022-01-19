import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overscript/repositories/stored_string_pair.dart';

part 'stored_variable.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class StoredVariable extends Equatable {
  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final List<StringPair> branchValues;

  const StoredVariable.empty()
      : uuid = '',
        name = '',
        branchValues = const [];

  const StoredVariable({required this.uuid, required this.name, required this.branchValues});

  factory StoredVariable.fromJson(Map json) => _$StoredVariableFromJson(json);

  Map<String, dynamic> toJson() => _$StoredVariableToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, name, branchValues];
}
