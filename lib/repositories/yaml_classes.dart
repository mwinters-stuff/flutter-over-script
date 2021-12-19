import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interpolator/interpolator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/utils/run_docker.dart';

import 'repositories.dart';

part 'yaml_classes.g.dart';

enum option { yes, no, both }

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class YamlTab {
  @JsonKey(required: true)
  final String title;
  @JsonKey(required: false)
  final Map<String, option>? options;

  @JsonKey(required: false, name: 'docker-path')
  final String? dockerPath;

  @JsonKey(required: false)
  final List<String>? commands;

  YamlTab({required this.title, this.commands, this.options, this.dockerPath}) {
    if (title.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Cannot be empty.');
    }
    if (indocker() == option.yes &&
        buildallmaster() == option.no &&
        dockerPath!.isEmpty) {
      throw ArgumentError.value(
          title, 'docker-path', 'Cannot be empty when indocker.');
    }
    if (buildallmaster() == option.yes && buildall() == option.yes) {
      throw ArgumentError.value(title, 'buildall-master',
          'Cannot be yes when option buildall = yes.');
    }
    if (buildallmaster() == option.both) {
      throw ArgumentError.value(title, 'buildall-master', 'Cannot be both.');
    }
    if (buildall() == option.both) {
      throw ArgumentError.value(title, 'buildall', 'Cannot be both.');
    }
    if (buildallmaster() == option.no &&
        (commands == null || commands!.isEmpty)) {
      throw ArgumentError.value(title, 'commands', 'Cannot be empty.');
    }
  }

  option indocker() {
    if (options != null) {
      if (options!.containsKey('indocker')) {
        return options!['indocker']!;
      }
    }
    return option.no;
  }

  option forprism() {
    if (options != null) {
      if (options!.containsKey('forprism')) {
        return options!['forprism']!;
      }
    }
    return option.both;
  }

  option forguide() {
    if (options != null) {
      if (options!.containsKey('forguide')) {
        return options!['forguide']!;
      }
    }
    return option.both;
  }

  option buildallmaster() {
    if (options != null) {
      if (options!.containsKey('buildall-master')) {
        return options!['buildall-master']!;
      }
    }
    return option.no;
  }

  option buildall() {
    if (options != null) {
      if (options!.containsKey('buildall')) {
        return options!['buildall']!;
      }
    }
    return option.no;
  }

  factory YamlTab.fromJson(Map json) => _$YamlTabFromJson(json);

  Map<String, dynamic> toJson() => _$YamlTabToJson(this);
  @override
  String toString() => '${toJson()}';

  void execute(BuildContext context, Branch branch, bool singleScript) {
    final configurationRepository =
        RepositoryProvider.of<ConfigurationRepository>(context);
    final kittyRepository = RepositoryProvider.of<KittyRepository>(context);

    if (!singleScript) {
      if (configurationRepository.useGuide.getValue() &&
          forguide() == option.no) {
        return;
      }

      if (!configurationRepository.useGuide.getValue() &&
          forguide() == option.yes) {
        return;
      }

      if (configurationRepository.usePrism.getValue() &&
          forprism() == option.no) {
        return;
      }

      if (!configurationRepository.usePrism.getValue() &&
          forprism() == option.yes) {
        return;
      }
    }

    final interpolate = branch.getInterpolate(
        context,
        configurationRepository.useGuide.getValue(),
        configurationRepository.scriptPath.getValue());
    if (interpolate == null) {
      return;
    }

    if (indocker() == option.yes) {
      for (var command in commands!) {
        if (command.isNotEmpty) {
          final intercommand = Interpolator(command)(interpolate);
          dog.i('Run in docker "$intercommand"');

          if (configurationRepository.useKitty.getValue()) {
            kittyRepository.addPtyDocker(
                context,
                interpolate['root']!,
                configurationRepository.scriptPath.getValue(),
                dockerPath!,
                title,
                intercommand);
          } else {
            runDockerInTab(
                context,
                interpolate['root']!,
                configurationRepository.scriptPath.getValue(),
                dockerPath!,
                title,
                intercommand);
          }
        }
      }
    } else {
      final newCommands = <String>[];
      for (var command in commands!) {
        if (command.isNotEmpty) {
          final intercommand = Interpolator(command)(interpolate);
          dog.i('Run in tab "$intercommand"');
          newCommands.add(intercommand);
        }
      }
      if (configurationRepository.useKitty.getValue()) {
        kittyRepository.addPty(
            context, title, newCommands, interpolate['root']!);
      } else {
        BlocProvider.of<PtyBloc>(context).add(PtyAddEvent(
            tabTitle: title,
            commands: newCommands,
            workingDirectory: interpolate['root']));
      }
    }
  }
}

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class YamlScript {
  @JsonKey(required: true)
  final String button;
  @JsonKey(required: true)
  final List<YamlTab> tabs;

  YamlScript({required this.button, required this.tabs}) {
    if (button.isEmpty) {
      throw ArgumentError.value(button, 'button', 'Cannot be empty.');
    }
    if (tabs.isEmpty) {
      throw ArgumentError.value(button, 'tabs', 'Cannot be empty.');
    }
  }

  factory YamlScript.fromJson(Map json) => _$YamlScriptFromJson(json);

  Map<String, dynamic> toJson() => _$YamlScriptToJson(this);

  @override
  String toString() => '${toJson()}';

  void execute(BuildContext context, Branch branch) {
    dog.i('run script ${toString()}');

    for (var tab in tabs) {
      if (tab.buildallmaster() == option.no) {
        tab.execute(context, branch, tabs.length == 1);
      } else {
        final scripts = RepositoryProvider.of<ScriptsRepository>(context)
            .getBuildAllScripts();
        for (var element in scripts) {
          element.execute(context, branch);
        }
      }
    }
  }
}

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class YamlScripts {
  @JsonKey(required: true)
  final List<YamlScript> scripts;

  YamlScripts({required this.scripts}) {
    if (scripts.isEmpty) {
      throw ArgumentError.value(scripts, 'scripts', 'Cannot be empty.');
    }
  }

  factory YamlScripts.fromJson(Map json) => _$YamlScriptsFromJson(json);

  Map<String, dynamic> toJson() => _$YamlScriptsToJson(this);

  @override
  String toString() => '${toJson()}';
}
