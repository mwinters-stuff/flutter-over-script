import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stored_string_pair.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class StringPair extends Equatable {
  @JsonKey(required: true)
  final String value1;
  @JsonKey(required: true)
  final String value2;

  const StringPair(this.value1, this.value2);

  @override
  String toString() {
    return value1 + "=" + value2;
  }

  Map<String, dynamic> toJson() => _$StringPairToJson(this);
  factory StringPair.fromJson(Map json) => _$StringPairFromJson(json);

  @override
  List<Object?> get props => [value1, value2];
}
