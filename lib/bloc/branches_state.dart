part of 'branches_bloc.dart';

@immutable
abstract class BranchesState extends Equatable {
  const BranchesState();
  @override
  List<Object> get props => [];
}

class BranchesInitial extends BranchesState {}

class BranchesLoadedState extends BranchesState {
  final List<Branch> branches;
  const BranchesLoadedState({required this.branches});
  @override
  List<Object> get props => [branches];
}
