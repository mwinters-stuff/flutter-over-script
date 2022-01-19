import 'dart:convert';
import 'dart:io';

import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/repositories/stored_json.dart';

class DataStoreRepository {
  List<StoredScript> _scripts;
  List<StoredVariable> _variables;

  get scripts => _scripts;
  get variables => _variables;

  DataStoreRepository()
      : _scripts = [],
        _variables = [];

  String? checkScriptNameUsed(String name) {
    for (var script in _scripts) {
      if (name == script.name) {
        return script.uuid;
      }
    }
    return null;
  }

  String? checkVariableNameUsed(String name) {
    for (var variable in _variables) {
      if (name == variable.name) {
        return variable.uuid;
      }
    }
    return null;
  }

  void load(String filename) {
    final file = File(filename);
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      var storedJson = StoredJson.fromJson(const JsonDecoder().convert(content));
      _scripts = List.from(storedJson.scripts);
      _variables = List.from(storedJson.variables);
    }
  }

  StoredScript? get(String uuid) {
    try {
      return _scripts.firstWhere((element) => element.uuid == uuid);
    } on StateError catch (_, __) {
      return null;
    }
  }

  void addScript(
      {required String uuid,
      required String name,
      required String command,
      required List<String> args,
      required String workingDirectory,
      required bool runInDocker,
      required List<StringPair> envVars}) {
    if (checkScriptNameUsed(name) == null) {
      _scripts.add(StoredScript(uuid: uuid, name: name, command: command, args: args, workingDirectory: workingDirectory, runInDocker: runInDocker, envVars: envVars));
    }
  }

  void editScript(
      {required String uuid,
      required String name,
      required String command,
      required List<String> args,
      required String workingDirectory,
      required bool runInDocker,
      required List<StringPair> envVars}) {
    String? usedUuid = checkScriptNameUsed(name);
    if (usedUuid == null || usedUuid == uuid) {
      deleteScript(uuid);
      _scripts.add(StoredScript(uuid: uuid, name: name, command: command, args: args, workingDirectory: workingDirectory, runInDocker: runInDocker, envVars: envVars));
    }
  }

  void deleteScript(String uuid) {
    _scripts.removeWhere((element) => element.uuid == uuid);
  }

  void addVariable({required String uuid, required String name, required List<StringPair> branchValues}) {
    if (checkVariableNameUsed(name) == null) {
      _variables.add(StoredVariable(uuid: uuid, name: name, branchValues: branchValues));
    }
  }

  void editVariable({required String uuid, required String name, required List<StringPair> branchValues}) {
    String? usedUuid = checkVariableNameUsed(name);
    if (usedUuid == null || usedUuid == uuid) {
      deleteVariable(uuid);
      _variables.add(StoredVariable(uuid: uuid, name: name, branchValues: branchValues));
    }
  }

  void deleteVariable(String uuid) {
    _variables.removeWhere((element) => element.uuid == uuid);
  }

  void save(String filename) {
    var storedJson = StoredJson(scripts: _scripts, variables: _variables);
    var output = const JsonEncoder.withIndent('  ').convert(storedJson);
    File(filename).writeAsStringSync(output);
  }
}
