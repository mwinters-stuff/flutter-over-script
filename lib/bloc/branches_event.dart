part of 'branches_bloc.dart';

@immutable
abstract class BranchesEvent extends Equatable {
  const BranchesEvent();
  @override
  List<Object> get props => [];
}

class BranchesRequestEvent extends BranchesEvent {}
