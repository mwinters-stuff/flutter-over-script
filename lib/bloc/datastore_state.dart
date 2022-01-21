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
  final List<StoredBranch> branches;

  const DataStoreUpdated(this.scripts, this.variables, this.branches);

  @override
  List<Object> get props => [scripts, variables, branches];
}

class DataStoreSaving extends DataStoreUpdated {
  const DataStoreSaving(List<StoredScript> scripts, List<StoredVariable> variables, List<StoredBranch> branches) : super(scripts, variables, branches);
}

class DataStoreSaved extends DataStoreUpdated {
  const DataStoreSaved(List<StoredScript> scripts, List<StoredVariable> variables, List<StoredBranch> branches) : super(scripts, variables, branches);
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
