import 'dart:convert';
import 'dart:io';

import 'package:overscript/repositories/repositories.dart';

class ScriptsStoreRepository {
  StoredScripts _storedScripts;

  get scripts => _storedScripts.scripts;

  ScriptsStoreRepository() : _storedScripts = StoredScripts();

  bool checkNameUsed(String name) {
    for (var script in _storedScripts.scripts) {
      if (name == script.name) {
        return true;
      }
    }
    return false;
  }

  void load(String filename) {
    final file = File(filename);
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      _storedScripts =
          StoredScripts.fromJson(const JsonDecoder().convert(content));
    }
  }

  StoredScript? get(String uuid) {
    try {
      return _storedScripts.scripts
          .firstWhere((element) => element.uuid == uuid);
    } on StateError catch (_, __) {
      return null;
    }
  }

  void add(
      {required String uuid,
      required String name,
      required String command,
      required List<String> args,
      required String workingDirectory,
      required bool runInDocker,
      required Map<String, String> envVars}) {
    if (!checkNameUsed(name)) {
      StoredScript script = StoredScript(
          uuid: uuid,
          name: name,
          command: command,
          args: args,
          workingDirectory: workingDirectory,
          runInDocker: runInDocker,
          envVars: envVars);
      _storedScripts.scripts.add(script);
    }
  }

  void edit(
      {required String uuid,
      required String name,
      required String command,
      required List<String> args,
      required String workingDirectory,
      required bool runInDocker,
      required Map<String, String> envVars}) {
    delete(uuid);
    add(
        uuid: uuid,
        name: name,
        command: command,
        args: args,
        workingDirectory: workingDirectory,
        runInDocker: runInDocker,
        envVars: envVars);
  }

  void delete(String uuid) {
    _storedScripts.scripts.removeWhere((element) => element.uuid == uuid);
  }

  void save(String filename) {
    var output = const JsonEncoder.withIndent('  ').convert(_storedScripts);
    File(filename).writeAsStringSync(output);
  }
}
