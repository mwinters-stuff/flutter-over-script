part of 'datastore_bloc.dart';

abstract class DataStoreState extends Equatable {
  const DataStoreState();

  @override
  List<Object> get props => [];
}

class DataStoreInitial extends DataStoreState {}

class DataStoreLoading extends DataStoreState {}

class DataStoreUpdating extends DataStoreState {}

class DataStoreUpdated extends DataStoreState {
  final List<StoredScript> scripts;
  final List<StoredVariable> variables;

  const DataStoreUpdated(this.scripts, this.variables);

  @override
  List<Object> get props => [scripts, variables];
}

class DataStoreSaving extends DataStoreState {
  final List<StoredScript> scripts;
  final List<StoredVariable> variables;

  const DataStoreSaving(this.scripts, this.variables);

  @override
  List<Object> get props => [scripts, variables];
}

class DataStoreSaved extends DataStoreState {
  final List<StoredScript> scripts;
  final List<StoredVariable> variables;

  const DataStoreSaved(this.scripts, this.variables);

  @override
  List<Object> get props => [scripts, variables];
}

// class DataStoreScriptsUpdated extends DataStoreState {
//   final List<StoredScript> scripts;

//   const DataStoreScriptsUpdated(this.scripts);

//   @override
//   List<Object> get props => [scripts];
// }

// class DataStoreVariablesUpdated extends DataStoreState {
//   final List<StoredVariable> variables;

//   const DataStoreVariablesUpdated(this.variables);

//   @override
//   List<Object> get props => [variables];
// }
