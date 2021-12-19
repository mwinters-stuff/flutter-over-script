import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

part 'pty_event.dart';
part 'pty_state.dart';

class PtyBloc extends Bloc<PtyEvent, PtyState> {
  final PtyRepository repository;

  PtyBloc({required this.repository}) : super(PtyInitialState()) {
    on<PtyAddEvent>(_onPtyAddEvent);
    on<PtyCompleteEvent>(_onPtyComplete);
    on<PtyRemoveEvent>(_onPtyRemove);
  }

  FutureOr<void> _onPtyAddEvent(PtyAddEvent event, Emitter<PtyState> emit) {
    emit(PtyAddingTerminalState(
        terminals: repository.ptys,
        tabTitle: event.tabTitle,
        commands: event.commands,
        workingDirectory: event.workingDirectory));
    emit(PtyTerminalsState(terminals: repository.ptys));
  }

  FutureOr<void> _onPtyComplete(
      PtyCompleteEvent event, Emitter<PtyState> emit) {
    emit(PtyRemovingTerminalState(terminals: repository.ptys));
    repository.completePty(uuid: event.uuid);
    emit(PtyTerminalsState(terminals: repository.ptys));
  }

  FutureOr<void> _onPtyRemove(PtyRemoveEvent event, Emitter<PtyState> emit) {
    emit(PtyRemovingTerminalState(terminals: repository.ptys));
    repository.removePty(uuid: event.uuid);
    emit(PtyTerminalsState(terminals: repository.ptys));
  }
}
