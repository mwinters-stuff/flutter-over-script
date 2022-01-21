import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stored_branch.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class StoredBranch extends Equatable {
  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String directory;

  const StoredBranch.empty()
      : uuid = '',
        name = '',
        directory = '';

  const StoredBranch({required this.uuid, required this.name, required this.directory});

  factory StoredBranch.fromJson(Map json) => _$StoredBranchFromJson(json);

  Map<String, dynamic> toJson() => _$StoredBranchToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, name, directory];
}
