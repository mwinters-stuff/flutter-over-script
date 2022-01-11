import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/repositories/stored_script.dart';
import 'package:uuid/uuid.dart';

part 'scriptsstore_event.dart';
part 'scriptsstore_state.dart';

class ScriptsStoreBloc extends Bloc<ScriptsStoreEvent, ScriptsStoreState> {
  ScriptsStoreBloc({required ScriptsStoreRepository repository})
      : super(ScriptsStoreInitial()) {
    on<ScriptStoreLoad>((event, emit) {
      repository.load(event.filename);
      emit(ScriptsStoreUpdated(repository.scripts));
    });
    on<ScriptStoreAdd>((event, emit) {
      repository.add(
          uuid: const Uuid().v1(),
          name: event.name,
          command: event.command,
          args: event.args,
          workingDirectory: event.workingDirectory,
          runInDocker: event.runInDocker,
          envVars: event.envVars);
      emit(ScriptsStoreUpdated(repository.scripts));
    });
    on<ScriptStoreEdit>((event, emit) {
      repository.edit(
          uuid: event.uuid,
          name: event.name,
          command: event.command,
          args: event.args,
          workingDirectory: event.workingDirectory,
          runInDocker: event.runInDocker,
          envVars: event.envVars);
      emit(ScriptsStoreUpdated(repository.scripts));
    });
    on<ScriptStoreDelete>((event, emit) {
      repository.delete(event.uuid);
      emit(ScriptsStoreUpdated(repository.scripts));
    });
    on<ScriptStoreSave>((event, emit) {
      repository.save(event.filename);
      emit(ScriptsStoreUpdated(repository.scripts));
    });
  }
}
