part of 'datastore_bloc.dart';

abstract class DataStoreEvent extends Equatable {
  const DataStoreEvent();
}

class DataStoreLoad extends DataStoreEvent {
  final String filename;
  const DataStoreLoad(this.filename);

  @override
  List<Object> get props => [filename];
}

class DataStoreSave extends DataStoreEvent {
  final String filename;
  const DataStoreSave(this.filename);

  @override
  List<Object> get props => [filename];
}

class ScriptStoreAddEvent extends DataStoreEvent {
  final String name;
  final String command;
  final List<String> args;
  final String workingDirectory;
  final bool runInDocker;
  final List<StringPair> envVars;
  const ScriptStoreAddEvent({required this.name, required this.command, required this.args, required this.workingDirectory, required this.runInDocker, required this.envVars});

  @override
  List<Object> get props => [name, command, args, workingDirectory, runInDocker, envVars];
}

class ScriptStoreEditEvent extends DataStoreEvent {
  final String uuid;
  final String name;
  final String command;
  final List<String> args;
  final String workingDirectory;
  final bool runInDocker;
  final List<StringPair> envVars;
  const ScriptStoreEditEvent({required this.uuid, required this.name, required this.command, required this.args, required this.workingDirectory, required this.runInDocker, required this.envVars});

  @override
  List<Object> get props => [uuid, name, command, args, workingDirectory, runInDocker, envVars];
}

class ScriptStoreDeleteEvent extends DataStoreEvent {
  final String uuid;
  const ScriptStoreDeleteEvent({required this.uuid});

  @override
  List<Object> get props => [uuid];
}

class VariableStoreAddEvent extends DataStoreEvent {
  final String name;
  final List<StringPair> branchValues;
  const VariableStoreAddEvent({required this.name, required this.branchValues});

  @override
  List<Object> get props => [name, branchValues];
}

class VariableStoreEditEvent extends DataStoreEvent {
  final String uuid;
  final String name;
  final List<StringPair> branchValues;
  const VariableStoreEditEvent({required this.uuid, required this.name, required this.branchValues});

  @override
  List<Object> get props => [uuid, name, branchValues];
}

class VariableStoreDeleteEvent extends DataStoreEvent {
  final String uuid;
  const VariableStoreDeleteEvent({required this.uuid});

  @override
  List<Object> get props => [uuid];
}
