import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';

part 'scripts_event.dart';
part 'scripts_state.dart';

class ScriptsBloc extends Bloc<ScriptsEvent, ScriptsState> {
  final ScriptsRepository scriptsRepository;
  final ConfigurationRepository configurationRepository;
  ScriptsBloc(
      {required this.scriptsRepository, required this.configurationRepository})
      : super(ScriptsInitial()) {
    on<ScriptsRequestEvent>(_onScriptsRequest);
    on<ScriptsReloadedEvent>(_onScriptsReloaded);
  }

  FutureOr<void> _onScriptsRequest(
      ScriptsRequestEvent event, Emitter<ScriptsState> emit) {
    final result = scriptsRepository.getScripts();
    emit(ScriptsLoadedState(scripts: result));
  }

  FutureOr<void> _onScriptsReloaded(
      ScriptsReloadedEvent event, Emitter<ScriptsState> emit) {
    emit(ScriptsInitial());
    scriptsRepository.reloadScripts(event.context).then((value) =>
        {emit(ScriptsLoadedState(scripts: scriptsRepository.getScripts()))});
  }
}
