part of 'scriptsstore_bloc.dart';

abstract class ScriptsStoreEvent extends Equatable {
  const ScriptsStoreEvent();
}

class ScriptStoreLoad extends ScriptsStoreEvent {
  final String filename;
  const ScriptStoreLoad(this.filename);

  @override
  List<Object> get props => [filename];
}

class ScriptStoreAdd extends ScriptsStoreEvent {
  final String name;
  final String command;
  final List<String> args;
  final String workingDirectory;
  final bool runInDocker;
  final Map<String, String> envVars;
  const ScriptStoreAdd(this.name, this.command, this.args,
      this.workingDirectory, this.runInDocker, this.envVars);

  @override
  List<Object> get props =>
      [name, command, args, workingDirectory, runInDocker, envVars];
}

class ScriptStoreEdit extends ScriptsStoreEvent {
  final String uuid;
  final String name;
  final String command;
  final List<String> args;
  final String workingDirectory;
  final bool runInDocker;
  final Map<String, String> envVars;
  const ScriptStoreEdit(this.uuid, this.name, this.command, this.args,
      this.workingDirectory, this.runInDocker, this.envVars);

  @override
  List<Object> get props =>
      [uuid, name, command, args, workingDirectory, runInDocker, envVars];
}

class ScriptStoreDelete extends ScriptsStoreEvent {
  final String uuid;
  const ScriptStoreDelete(this.uuid);

  @override
  List<Object> get props => [uuid];
}

class ScriptStoreSave extends ScriptsStoreEvent {
  final String filename;
  const ScriptStoreSave(this.filename);

  @override
  List<Object> get props => [filename];
}
