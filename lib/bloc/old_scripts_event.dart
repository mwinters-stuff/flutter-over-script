part of 'old_scripts_bloc.dart';

@immutable
abstract class OldScriptsEvent extends Equatable {
  const OldScriptsEvent();
  @override
  List<Object> get props => [];
}

class OldScriptsRequestEvent extends OldScriptsEvent {}

class OldScriptsReloadedEvent extends OldScriptsEvent {
  final BuildContext context;
  const OldScriptsReloadedEvent({required this.context});

  @override
  List<Object> get props => [context];
}
