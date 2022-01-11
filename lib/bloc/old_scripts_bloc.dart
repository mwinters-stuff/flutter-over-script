import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';

part 'old_scripts_event.dart';
part 'old_scripts_state.dart';

class OldScriptsBloc extends Bloc<OldScriptsEvent, OldScriptsState> {
  final OldScriptsRepository scriptsRepository;
  final ConfigurationRepository configurationRepository;
  OldScriptsBloc(
      {required this.scriptsRepository, required this.configurationRepository})
      : super(OldScriptsInitial()) {
    on<OldScriptsRequestEvent>(_onScriptsRequest);
    on<OldScriptsReloadedEvent>(_onScriptsReloaded);
  }

  FutureOr<void> _onScriptsRequest(
      OldScriptsRequestEvent event, Emitter<OldScriptsState> emit) {
    final result = scriptsRepository.getScripts();
    emit(OldScriptsLoadedState(scripts: result));
  }

  FutureOr<void> _onScriptsReloaded(
      OldScriptsReloadedEvent event, Emitter<OldScriptsState> emit) {
    emit(OldScriptsInitial());
    scriptsRepository.reloadScripts(event.context).then((value) =>
        {emit(OldScriptsLoadedState(scripts: scriptsRepository.getScripts()))});
  }
}
