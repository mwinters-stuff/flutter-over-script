import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:overscript/repositories/configuration_repository.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

part 'configuration_event.dart';
part 'configuration_state.dart';

class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {
  final ConfigurationRepository configurationRepository;

  ConfigurationBloc({required this.configurationRepository}) : super(ConfigurationInitialState()) {
    on<ConfigurationRequestEvent>(_onConfigurationRequest);
    on<ConfigurationChangedEvent>(_onConfigurationChanged);
  }

  Preference<String> get sourcePath => configurationRepository.sourcePath;
  Preference<String> get scriptPath => configurationRepository.scriptPath;
  Preference<String> get editorExecutable => configurationRepository.editorExecutable;
  Preference<String> get selectedBranchName => configurationRepository.selectedBranchName;
  Preference<bool> get useKitty => configurationRepository.useKitty;

  FutureOr<void> _onConfigurationRequest(ConfigurationRequestEvent event, Emitter<ConfigurationState> emit) {
    emit(ConfigurationLoadedState(configurationRepository: configurationRepository));
  }

  FutureOr<void> _onConfigurationChanged(ConfigurationChangedEvent event, Emitter<ConfigurationState> emit) {
    emit(ConfigurationChangedState());
  }
}
