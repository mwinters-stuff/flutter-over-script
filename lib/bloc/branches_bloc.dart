import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';

part 'branches_event.dart';
part 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final BranchRepository branchesRepository;
  final BuildContext context;
  BranchesBloc(this.context, {required this.branchesRepository})
      : super(BranchesInitial()) {
    on<BranchesRequestEvent>(_onBranchesState);
  }

  FutureOr<void> _onBranchesState(
      BranchesRequestEvent event, Emitter<BranchesState> emit) {
    branchesRepository
        .getBranches(context)
        .then((value) => emit(BranchesLoadedState(branches: value)));
  }
}
