import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/scripts_bloc.dart';
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
    BlocProvider.of<ScriptsBloc>(context).add(ScriptsRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    final configurationRepository =
        RepositoryProvider.of<ConfigurationRepository>(context);

    return BlocConsumer<ScriptsBloc, ScriptsState>(listener: (context, state) {
      if (state is ScriptsInitial) {}
    }, builder: (context, state) {
      if (state is ScriptsLoadedState) {
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
    final script = RepositoryProvider.of<ScriptsRepository>(context)
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
