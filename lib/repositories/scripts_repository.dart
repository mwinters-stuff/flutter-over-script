import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:path/path.dart' as p;

class ScriptsRepository {
  late YamlScripts _yamlScripts;
  List<YamlScript> get scripts => _yamlScripts.scripts;

  ScriptsRepository(BuildContext context) {
    loadScripts(context);
  }

  Future<void> loadScripts(BuildContext context) async {
    final configurationRepository =
        RepositoryProvider.of<ConfigurationRepository>(context);

    final yamlContent = File(p.join(
            configurationRepository.scriptPath.getValue(), 'scripts.yaml'))
        .readAsStringSync();
    _yamlScripts = checkedYamlDecode(
      yamlContent,
      (m) => YamlScripts.fromJson(m!),
      sourceUrl: null,
    );
    return Future.value(null);
  }

  Future<void> reloadScripts(BuildContext context) async {
    await loadScripts(context);
  }

  List<YamlScript> getScripts() => scripts;

  YamlScript? getScriptFromName({required String name}) {
    for (var element in scripts) {
      if (element.button == name) {
        return element;
      }
    }

    return null;
  }

  List<YamlScript> getBuildAllScripts() {
    var result = <YamlScript>[];
    for (var script in scripts) {
      for (var tab in script.tabs) {
        if (tab.buildall() == option.yes) {
          result.add(script);
        }
      }
    }
    return result;
  }
}
