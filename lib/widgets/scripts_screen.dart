import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/repositories/stored_script.dart';
import 'package:overscript/widgets/script_card.dart';
import 'package:overscript/widgets/script_edit_screen.dart';

class ScriptsScreen extends StatefulWidget {
  static const routeName = '/scripts';

  const ScriptsScreen({Key? key}) : super(key: key);
  @override
  _ScriptsScreenState createState() => _ScriptsScreenState();
}

class _ScriptsScreenState extends State<ScriptsScreen> {
  final List<StoredScript> _selected = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ScriptsStoreBloc>(context)
        .add(const ScriptStoreLoad("testfile.json"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scripts'),
        actions: [
          IconButton(
              tooltip: 'Add Script',
              onPressed: () =>
                  Navigator.pushNamed(context, ScriptEditScreen.routeNameAdd),
              icon: const Icon(Icons.add)),
          IconButton(
              color: _selected.length == 1
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).disabledColor,
              tooltip: 'Edit Script',
              onPressed: () => _selected.length == 1
                  ? Navigator.pushNamed(context, ScriptEditScreen.routeNameEdit,
                      arguments: _selected[0].uuid)
                  : null,
              icon: const Icon(Icons.edit)),
          IconButton(
              color: _selected.isEmpty
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).iconTheme.color,
              tooltip: 'Delete Script',
              onPressed: () => _selected.isEmpty ? null : {},
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: buildScriptsList(),
    );
  }

  Widget buildScriptsList() {
    return BlocConsumer<ScriptsStoreBloc, ScriptsStoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ScriptsStoreUpdated) {
            return Wrap(
              children: state.scripts
                  .map<Widget>((StoredScript script) => ScriptCard(
                        storedScript: script,
                        selectedCallback: (script, selected) {
                          setState(() {
                            _selected.removeWhere(
                                (element) => element.uuid == script.uuid);
                            if (selected) {
                              _selected.add(script);
                            }
                          });
                        },
                      ))
                  .toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
