import 'dart:async';

import 'package:ansicolor/ansicolor.dart';
import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:pty/pty.dart';
import 'package:xterm/xterm.dart';
import 'package:uuid/uuid.dart';

class PtyTerminalTabBackend extends TerminalBackend {
  late final Completer<int> _exitCodeCompleter;
  final BuildContext context;
  late final PseudoTerminal pty;

  final String workingDirectory;
  final String tabTitle;
  final List<String> commands;
  final String _uuid = const Uuid().v1();

  String get uuid => _uuid;

  PtyTerminalTabBackend(
      {required this.context,
      required this.tabTitle,
      required this.commands,
      required this.workingDirectory});

  @override
  void ackProcessed() {
    // NOOP
  }

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  void init() {
    _exitCodeCompleter = Completer<int>();

    pty = PseudoTerminal.start(
      'bash',
      ['-i'],
      workingDirectory: workingDirectory,
      environment: {'TERM': 'xterm-256color'},
    );

    pty.exitCode.then((value) {
      dog.i('command complete ');
      _exitCodeCompleter.complete(value);
    });

    for (var command in commands) {
      pty.write('$command \n');
    }
  }

  @override
  Stream<String> get out => pty.out;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    pty.resize(width, height);
  }

  @override
  void terminate() {
    for (var i = 0; i < 10; i++) {
      pty.write(String.fromCharCode(0x02));
    }

    pty.kill();
  }

  @override
  void write(String input) {
    pty.write(input);
  }
}

class PtyRepository {
  final List<Terminal> _ptys = <Terminal>[];

  List<Terminal> get ptys => _ptys;

  void addPty(
      {required context,
      required tabTitle,
      required commands,
      required workingDirectory}) {
    final pty = PtyTerminalTabBackend(
        context: context,
        tabTitle: tabTitle,
        commands: commands,
        workingDirectory: workingDirectory);
    final terminal = Terminal(
      backend: pty,
      maxLines: 5000,
      platform: PlatformBehaviors.unix,
    );
    pty.exitCode.then((value) {
      // BlocProvider.of<PtyBloc>(context).add(PtyCompleteEvent(uuid: pty.uuid));
      var pen = AnsiPen()..red();
      terminal.write(pen('\r\n\r\n\r\n$tabTitle Finished with code $value'));
    });
    _ptys.add(terminal);

    // commands.forEach((command) {
    //   terminal.write('$command \n');
    // });
  }

  void completePty({required String uuid}) {
    _ptys.removeWhere(
        (element) => (element.backend as PtyTerminalTabBackend).uuid == uuid);
  }

  void removePty({required String uuid}) {
    final Terminal? terminal = _ptys.firstWhere(
        (element) => (element.backend as PtyTerminalTabBackend).uuid == uuid,
        orElse: () => null as Terminal);
    if (terminal == null) {
      return;
    }

    terminal.terminateBackend();
    _ptys.remove(terminal);
  }

  void closeAll(BuildContext context) {
    for (var element in _ptys) {
      BlocProvider.of<PtyBloc>(context).add(PtyRemoveEvent(
          uuid: (element.backend as PtyTerminalTabBackend).uuid));
    }
  }
}
