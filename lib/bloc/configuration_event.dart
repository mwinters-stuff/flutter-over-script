part of 'configuration_bloc.dart';

@immutable
abstract class ConfigurationEvent extends Equatable {
  const ConfigurationEvent();

  @override
  List<Object> get props => [];
}

class ConfigurationRequestEvent extends ConfigurationEvent {}

class ConfigurationChangedEvent extends ConfigurationEvent {}
