part of 'kitty_bloc.dart';

@immutable
abstract class KittyState extends Equatable {
  const KittyState();
  @override
  List<Object> get props => [];
}

class KittyInitialState extends KittyState {}

class KittyAddingTerminalState extends KittyState {
  final String tabTitle;
  final List<String> commands;
  final String workingDirectory;

  const KittyAddingTerminalState(
      {required this.tabTitle,
      required this.commands,
      required this.workingDirectory})
      : super();

  @override
  List<Object> get props => [tabTitle, commands, workingDirectory];
}
