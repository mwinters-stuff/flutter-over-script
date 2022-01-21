part of 'configuration_bloc.dart';

@immutable
abstract class ConfigurationState extends Equatable {
  const ConfigurationState();
  @override
  List<Object> get props => [];
}

class ConfigurationInitialState extends ConfigurationState {}

class ConfigurationChangedState extends ConfigurationState {}

class ConfigurationLoadedState extends ConfigurationState {
  final ConfigurationRepository configurationRepository;

  const ConfigurationLoadedState({required this.configurationRepository});
  Preference<String> get sourcePath => configurationRepository.sourcePath;
  Preference<String> get scriptPath => configurationRepository.scriptPath;
  Preference<String> get editorExecutable => configurationRepository.editorExecutable;
  Preference<String> get selectedBranchName => configurationRepository.selectedBranchName;
  Preference<bool> get useKitty => configurationRepository.useKitty;
  Preference<String> get scriptDataFile => configurationRepository.scriptDataFile;

  @override
  List<Object> get props => [configurationRepository];
}
