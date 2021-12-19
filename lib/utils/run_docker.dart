import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';

void runDockerInTab(
  BuildContext context,
  String earthworksHome,
  String scriptPath,
  String dockerPath,
  String windowTitle,
  String args,
) {
  final cmdArgs =
      createDockerCommandLine(earthworksHome, scriptPath, dockerPath, args);

  BlocProvider.of<PtyBloc>(context).add(PtyAddEvent(
      tabTitle: windowTitle,
      commands: [cmdArgs.join(' ')],
      workingDirectory: earthworksHome));
}

List<String> createDockerCommandLine(
    String earthworksHome, String scriptPath, String dockerPath, String args) {
  final uid = Process.runSync('id', ['-u']).stdout.toString().trim();

  final dockerImageName = File('$earthworksHome/$dockerPath/.docker_image_name')
      .readAsStringSync()
      .trim();
  final homeEnv = Platform.environment['HOME']!;

  var cmd = <String>[
    'exec',
    '/usr/bin/docker',
    'run',
    '-it',
    '-e __USING_CTCT_DOCKER_RUNNER__=1',
    '--user="$uid:$uid"',
    '-w="$earthworksHome"',
    '-v /dev/shm:/dev/shm',
    '-v /tmp:/tmp',
    '--privileged',
    '--rm',
    '--dns 10.3.30.10',
    '--net=host',
    // '--env=HOME="$earthworksHome"',

    '--mount type=bind,source="$scriptPath/Docker,target=/Docker"',
    '--mount type=bind,source="$earthworksHome,target=$earthworksHome"',
    '--mount type=bind,source="$homeEnv/.ssh,target=/home/tonkatest/.ssh"',
    '--mount type=bind,source="$homeEnv/.gradle/gradle.properties,target=/home/tonkatest/.gradle/gradle.properties"',
    '--mount type=bind,source="$earthworksHome/../thirdparty,target=$earthworksHome/../thirdparty"',
    '"$dockerImageName"',
  ];
  cmd.add(args);
  return cmd;
}
