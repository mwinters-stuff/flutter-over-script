import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:overscript/utils/run_docker.dart';
import 'package:path/path.dart' as p;

class KittyTab {
  KittyTab(this.title, this.workingDirectory, this.commands);
  String title;
  String workingDirectory;
  List<String> commands;
}

class KittyRepository {
  final _kittyPath = p.join(Platform.environment['HOME']!, '.local/bin/kitty');
  final _kittyPipe = '/tmp/kitty-overscript';
  final _mutex = Mutex();

  Future<bool> _checkAndStartKitty() async {
    // check the pipe exists, if it does dont start kitty.
    var exists = await File(_kittyPipe).exists();
    if (!exists) {
      // kittyIds.clear();
      dog.e('Starting Kitty!!!');
      await Process.start(_kittyPath, [
        '-o',
        'allow_remote_control=yes',
        '--listen-on',
        'unix:$_kittyPipe'
      ]);

      return Future.delayed(
          const Duration(seconds: 1), () => Future.value(true));
    } else {
      dog.i('Kitty already running');
      return Future.value(false);
    }
  }

  void addPty(BuildContext context, String tabTitle, List<String> commands,
      String workingDirectory) {
    _addKittyTab(KittyTab(tabTitle, workingDirectory, commands));
  }

  Future<void> _addKittyTab(KittyTab tab) async {
    final started =
        await _mutex.protect<bool>(() async => _checkAndStartKitty());

    if (started) {
      Process.runSync(_kittyPath,
          ['@', '--to', 'unix:$_kittyPipe', 'set-tab-title', tab.title]);
      Process.runSync(_kittyPath, [
        '@',
        '--to',
        'unix:$_kittyPipe',
        'send-text',
        '--match-tab',
        'title:${tab.title}',
        'cd ${tab.workingDirectory}\n'
      ]);
    } else {
      Process.runSync(_kittyPath, [
        '@',
        '--to',
        'unix:$_kittyPipe',
        'new-window',
        '--new-tab',
        '--tab-title',
        tab.title,
        '--cwd',
        tab.workingDirectory,
      ]);
    }

    for (var command in tab.commands) {
      Process.runSync(_kittyPath, [
        '@',
        '--to',
        'unix:$_kittyPipe',
        'send-text',
        '--match-tab',
        'title:${tab.title}',
        '$command\n'
      ]);
    }
  }

  Future<List<dynamic>> getKittyListing() async {
    var exists = await File(_kittyPipe).exists();

    if (exists) {
      var result =
          Process.runSync(_kittyPath, ['@', '--to', 'unix:$_kittyPipe', 'ls']);

      var decoded = jsonDecode(result.stdout);
      if (decoded[0].containsKey('tabs')) {
        return Future.value(decoded[0]['tabs']);
      }
    }
    return Future.value([]);
  }

  void closeAll(BuildContext context) {
    getKittyListing().then((tabs) => {
          for (var tab in tabs)
            {
              Process.runSync(_kittyPath, [
                '@',
                '--to',
                'unix:$_kittyPipe',
                'close-tab',
                '--match',
                'id:${tab['id']}'
              ])
            }
        });
  }

  void addPtyDocker(BuildContext context, String earthworksHome,
      String scriptPath, String dockerPath, String windowTitle, String args) {
    final cmdArgs =
        createDockerCommandLine(earthworksHome, scriptPath, dockerPath, args)
            .sublist(1);
    _addKittyTab(KittyTab(windowTitle, earthworksHome, [cmdArgs.join(' ')]));
  }
}
