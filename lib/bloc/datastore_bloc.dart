import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

part 'datastore_event.dart';
part 'datastore_state.dart';

class DataStoreBloc extends Bloc<DataStoreEvent, DataStoreState> {
  DataStoreBloc({required DataStoreRepository repository}) : super(DataStoreInitial()) {
    on<DataStoreLoad>((event, emit) {
      emit(DataStoreLoading());
      repository.load(event.filename);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });

    on<DataStoreSave>((event, emit) {
      emit(DataStoreSaving(repository.scripts, repository.variables, repository.branches));
      repository.save(event.filename);
      emit(DataStoreSaved(repository.scripts, repository.variables, repository.branches));
    });

    on<ScriptStoreAddEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.addScript(
          uuid: const Uuid().v1(), name: event.name, command: event.command, args: event.args, workingDirectory: event.workingDirectory, runInDocker: event.runInDocker, envVars: event.envVars);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });
    on<ScriptStoreEditEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.editScript(
          uuid: event.uuid, name: event.name, command: event.command, args: event.args, workingDirectory: event.workingDirectory, runInDocker: event.runInDocker, envVars: event.envVars);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });
    on<ScriptStoreDeleteEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.deleteScript(event.uuid);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });

    on<VariableStoreAddEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.addVariable(uuid: const Uuid().v1(), name: event.name, branchValues: event.branchValues);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });
    on<VariableStoreEditEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.editVariable(uuid: event.uuid, name: event.name, branchValues: event.branchValues);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });
    on<VariableStoreDeleteEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.deleteVariable(event.uuid);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });

    on<BranchStoreAddEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.addBranch(uuid: const Uuid().v1(), name: event.name, directory: event.directory);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });
    on<BranchStoreEditEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.editBranch(uuid: event.uuid, name: event.name, directory: event.directory);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });
    on<BranchStoreDeleteEvent>((event, emit) {
      emit(DataStoreUpdating());
      repository.deleteBranch(event.uuid);
      emit(DataStoreUpdated(repository.scripts, repository.variables, repository.branches));
    });
  }
}
