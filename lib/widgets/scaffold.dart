import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/branches/branches.dart';
import 'package:overscript/widgets/settings_screen.dart';
import 'package:overscript/widgets/variables/variables.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:window_manager/window_manager.dart';

import 'scripts/scripts.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> with WindowListener, TickerProviderStateMixin {
  late TabController _tabController;
  bool useKitty = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    setState(() {
      final repositoryProvider = RepositoryProvider.of<ConfigurationRepository>(context);
      useKitty = repositoryProvider.useKitty.getValue();
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() {
    _saveWindowBounds();
  }

  @override
  void onWindowMove() {
    _saveWindowBounds();
  }

  void _saveWindowBounds() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () => windowManager.getBounds().then((value) => RepositoryProvider.of<ConfigurationRepository>(context).windowRect.setValue(value)));
  }

  @override
  Widget build(BuildContext context) {
    final configurationRepository = RepositoryProvider.of<ConfigurationRepository>(context);
    return BlocConsumer<PtyBloc, PtyState>(listener: (context, state) {
      if (state is PtyAddingTerminalState) {
        RepositoryProvider.of<PtyRepository>(context).addPty(context: context, tabTitle: state.tabTitle, commands: state.commands, workingDirectory: state.workingDirectory);
      }
    }, builder: (context, state) {
      // if (state is PtyTerminalsState) {
      _tabController = TabController(length: state.terminals.length, vsync: this);
      if (state.terminals.isNotEmpty) {
        _tabController.animateTo(state.terminals.length - 1);
      }
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Close All Tabs',
                  onPressed: () {
                    RepositoryProvider.of<PtyRepository>(context).closeAll(context);
                    RepositoryProvider.of<KittyRepository>(context).closeAll(context);
                  }),
              IconButton(tooltip: 'Reload Scripts', onPressed: () => BlocProvider.of<OldScriptsBloc>(context).add(OldScriptsReloadedEvent(context: context)), icon: const Icon(Icons.refresh)),
              IconButton(
                  tooltip: 'Edit Scripts',
                  onPressed: () => {
                        Process.runSync(configurationRepository.editorExecutable.getValue(), [p.join(configurationRepository.scriptPath.getValue(), 'scripts.yaml')])
                      },
                  icon: const Icon(Icons.edit)),
              IconButton(tooltip: 'Scripts', onPressed: () => Navigator.of(context).pushNamed(ScriptsScreen.routeName), icon: const Icon(Icons.subscript_sharp)),
              IconButton(tooltip: 'Branches', onPressed: () => Navigator.of(context).pushNamed(BranchesScreen.routeName), icon: const Icon(Icons.texture_rounded)),
              IconButton(tooltip: 'Variables', onPressed: () => Navigator.of(context).pushNamed(VariablesScreen.routeName), icon: const Icon(Icons.vertical_distribute)),
              IconButton(tooltip: 'Settings', onPressed: () => Navigator.of(context).pushNamed(SettingsScreen.routeName), icon: const Icon(Icons.settings))
            ],
            bottom: TabBar(controller: _tabController, tabs: state.getTabs(context: context)),
          ),
          body: Row(
            children: [
              SizedBox(
                  width: 300.0,
                  child: Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Branch',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              BranchPopupMenu(initialValue: configurationRepository.selectedBranchName.getValue(), onChanged: (value) => configurationRepository.selectedBranchName.setValue(value)),
                              Text(
                                'Options',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              CheckboxListTile(
                                  value: useKitty,
                                  onChanged: (value) {
                                    setState(() {
                                      useKitty = value!;
                                      configurationRepository.useKitty.setValue(value);
                                    });
                                  },
                                  title: const Text('External Terminal')),
                              Text(
                                'Script',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              const ScriptMenu(),
                            ],
                          )))),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: state.getTabViews(),
              ))
            ],
          ));

      // }
    });
  }
}
