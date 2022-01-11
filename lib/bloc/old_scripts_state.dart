part of 'old_scripts_bloc.dart';

@immutable
abstract class OldScriptsState extends Equatable {
  const OldScriptsState();
  @override
  List<Object> get props => [];
}

class OldScriptsInitial extends OldScriptsState {}

class OldScriptsLoadedState extends OldScriptsState {
  final List<YamlScript> scripts;
  const OldScriptsLoadedState({required this.scripts});
  @override
  List<Object> get props => [scripts];
}
