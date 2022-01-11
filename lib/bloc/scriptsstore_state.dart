part of 'scriptsstore_bloc.dart';

abstract class ScriptsStoreState extends Equatable {
  const ScriptsStoreState();

  @override
  List<Object> get props => [];
}

class ScriptsStoreInitial extends ScriptsStoreState {}

class ScriptsStoreUpdated extends ScriptsStoreState {
  final List<StoredScript> scripts;

  const ScriptsStoreUpdated(this.scripts);

  @override
  List<Object> get props => [scripts];
}
