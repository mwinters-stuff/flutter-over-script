import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:overscript/repositories/repositories.dart';

part 'kitty_event.dart';
part 'kitty_state.dart';

class KittyBloc extends Bloc<KittyEvent, KittyState> {
  final KittyRepository repository;

  KittyBloc({required this.repository}) : super(KittyInitialState()) {
    on<KittyAddEvent>(_onKittyAdd);
  }

  FutureOr<void> _onKittyAdd(KittyAddEvent event, Emitter<KittyState> emit) {
    emit(KittyAddingTerminalState(
        tabTitle: event.tabTitle,
        commands: event.commands,
        workingDirectory: event.workingDirectory));
  }
}
