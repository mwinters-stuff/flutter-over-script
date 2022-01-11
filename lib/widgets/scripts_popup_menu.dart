import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/old_scripts_bloc.dart';
import 'package:overscript/repositories/repositories.dart';

class ScriptMenu extends StatefulWidget {
  const ScriptMenu({Key? key}) : super(key: key);

  @override
  _ScriptMenuState createState() => _ScriptMenuState();
}

class _ScriptMenuState extends State<ScriptMenu> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OldScriptsBloc>(context).add(OldScriptsRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    final configurationRepository =
        RepositoryProvider.of<ConfigurationRepository>(context);

    return BlocConsumer<OldScriptsBloc, OldScriptsState>(
        listener: (context, state) {
      if (state is OldScriptsInitial) {}
    }, builder: (context, state) {
      if (state is OldScriptsLoadedState) {
        return Expanded(
            child: ListView.separated(
          padding: const EdgeInsets.all(2),
          itemCount: state.scripts.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
                onPressed: () {
                  runScript(context, state.scripts[index].button,
                      configurationRepository.selectedBranchName.getValue());
                },
                child: Text(state.scripts[index].button));
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 4,
            color: Colors.transparent,
          ),
        ));
      } else {
        return const Text('no scripts loaded');
      }
    });
  }

  void runScript(BuildContext context, String scriptName, String branchName) {
    dog.i('Run $scriptName on $branchName');
    final script = RepositoryProvider.of<OldScriptsRepository>(context)
        .getScriptFromName(name: scriptName);
    if (script == null) {
      dog.e('Script not found');
    }

    final branch = RepositoryProvider.of<BranchRepository>(context)
        .getBranchFromName(name: branchName);
    if (branch == null) {
      dog.e('Branch not found');
    }

    script?.execute(context, branch!);
  }
}
