import 'dart:io';

import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:overscript/utils/utils.dart';
import 'package:path/path.dart' as p;
import 'package:cool_alert/cool_alert.dart';

class Branch {
  String path;
  String name;
  String gitBranch;
  Branch(this.path, this.name, this.gitBranch);
  @override
  String toString() {
    return name;
  }

  Map<String, dynamic>? getInterpolate(BuildContext context, String scriptPath) {
    final root = path;
    final builtDir = p.join(root, 'built', 'linux');
    var duploHome = p.join(root, '..', 'DuploHomes', 'Duplo_$name');

    dog.i('Source $root Duplo Home $duploHome');

    if (!isDirectory(root)) {
      dog.e('$root is missing');
      CoolAlert.show(type: CoolAlertType.error, context: context, title: 'Failed to run', text: 'Source $root is missing', loopAnimation: false);
      return null;
    }

    if (!isDirectory(duploHome)) {
      dog.e('$duploHome is missing');
      CoolAlert.show(type: CoolAlertType.error, context: context, title: 'Failed to run', text: 'Duplo Home $duploHome is missing', loopAnimation: false);
      return null;
    }

    final result = <String, String>{};
    result['techUiRoot'] = p.join(root, 'built', 'web', 'TechUI', 'publish-earthworks');
    result['debugDir'] = p.join(builtDir, 'debug');
    result['pythonRoot'] = p.join(root, 'python');
    result['webport'] = '8080';
    result['duploHome'] = duploHome;
    result['builtDir'] = builtDir;
    result['root'] = root;
    result['scriptPath'] = scriptPath;
    result['ipAddress'] = getHostIPAddress();
    result['username'] = Platform.environment['USERNAME']!;
    return result;
  }
}
