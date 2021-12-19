part of 'kitty_bloc.dart';

@immutable
abstract class KittyEvent extends Equatable {
  const KittyEvent();
  @override
  List<Object> get props => [];
}

class KittyAddEvent extends KittyEvent {
  final String workingDirectory;
  final String tabTitle;
  final List<String> commands;

  const KittyAddEvent(
      {required this.tabTitle,
      required this.commands,
      required this.workingDirectory});

  @override
  List<Object> get props => [tabTitle, commands, workingDirectory];
}
