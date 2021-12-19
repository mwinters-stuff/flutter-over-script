part of 'scripts_bloc.dart';

@immutable
abstract class ScriptsEvent extends Equatable {
  const ScriptsEvent();
  @override
  List<Object> get props => [];
}

class ScriptsRequestEvent extends ScriptsEvent {}

class ScriptsReloadedEvent extends ScriptsEvent {
  final BuildContext context;
  const ScriptsReloadedEvent({required this.context});

  @override
  List<Object> get props => [context];
}
