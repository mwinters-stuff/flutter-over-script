part of 'pty_bloc.dart';

@immutable
abstract class PtyEvent extends Equatable {
  const PtyEvent();
  @override
  List<Object> get props => [];
}

class PtyAddEvent extends PtyEvent {
  final String workingDirectory;
  final String tabTitle;
  final List<String> commands;

  const PtyAddEvent(
      {required this.tabTitle,
      required this.commands,
      required this.workingDirectory});

  @override
  List<Object> get props => [tabTitle, commands, workingDirectory];
}

class PtyCompleteEvent extends PtyEvent {
  final String uuid;

  const PtyCompleteEvent({required this.uuid});

  @override
  List<Object> get props => [uuid];
}

class PtyRemoveEvent extends PtyEvent {
  final String uuid;

  const PtyRemoveEvent({required this.uuid});

  @override
  List<Object> get props => [uuid];
}

class PtyListEvent extends PtyEvent {
  final List<Terminal> terminals;

  const PtyListEvent({required this.terminals});

  @override
  List<Object> get props => [terminals];
}
