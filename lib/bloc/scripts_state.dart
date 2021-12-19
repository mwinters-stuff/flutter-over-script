part of 'scripts_bloc.dart';

@immutable
abstract class ScriptsState extends Equatable {
  const ScriptsState();
  @override
  List<Object> get props => [];
}

class ScriptsInitial extends ScriptsState {}

class ScriptsLoadedState extends ScriptsState {
  final List<YamlScript> scripts;
  const ScriptsLoadedState({required this.scripts});
  @override
  List<Object> get props => [scripts];
}
