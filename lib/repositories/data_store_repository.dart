import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/repositories/stored_json.dart';

class DataStoreRepository {
  List<StoredScript> _scripts;
  List<StoredVariable> _variables;
  List<StoredBranch> _branches;

  get scripts => _scripts;
  get variables => _variables;
  get branches => _branches;

  DataStoreRepository()
      : _scripts = [],
        _variables = [],
        _branches = [];

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

  String? checkBranchNameOrDirectoryUsed(String name, String directory) {
    for (var branch in _branches) {
      if (name == branch.name || directory == branch.directory) {
        return branch.uuid;
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
      _branches = List.from(storedJson.branches);
    }
  }

  StoredScript? getScript(String uuid) {
    try {
      return _scripts.firstWhere((element) => element.uuid == uuid);
    } on StateError catch (_, __) {
      return null;
    }
  }

  StoredVariable? getVariable(String uuid) {
    try {
      return _variables.firstWhere((element) => element.uuid == uuid);
    } on StateError catch (_, __) {
      return null;
    }
  }

  StoredBranch? getBranch(String uuid) {
    try {
      return _branches.firstWhere((element) => element.uuid == uuid);
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

  void addBranch({required String uuid, required String name, required String directory}) {
    if (checkBranchNameOrDirectoryUsed(name, directory) == null) {
      _branches.add(StoredBranch(uuid: uuid, name: name, directory: directory));
    }
  }

  void editBranch({required String uuid, required String name, required String directory}) {
    String? usedUuid = checkVariableNameUsed(name);
    if (usedUuid == null || usedUuid == uuid) {
      deleteBranch(uuid);
      _branches.add(StoredBranch(uuid: uuid, name: name, directory: directory));
    }
  }

  void deleteBranch(String uuid) {
    _branches.removeWhere((element) => element.uuid == uuid);
  }

  void save(String filename) {
    var storedJson = StoredJson(scripts: _scripts, variables: _variables, branches: _branches);
    var output = const JsonEncoder.withIndent('  ').convert(storedJson);
    File(filename).writeAsStringSync(output);
  }
}
