import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/scripts/script_card.dart';
import 'package:overscript/widgets/scripts/script_edit_screen.dart';
import 'package:overscript/widgets/scripts/script_list_item.dart';

class ScriptsScreen extends StatefulWidget {
  static const routeName = '/scripts';

  const ScriptsScreen({Key? key}) : super(key: key);
  @override
  _ScriptsScreenState createState() => _ScriptsScreenState();
}

class _ScriptsScreenState extends State<ScriptsScreen> {
  final List<StoredScript> _selected = [];
  bool _showGridView = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DataStoreBloc>(context).add(DataStoreLoad(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));
  }

  String _scriptsNameList(List<StoredScript> scripts) {
    String rv = "";
    for (var script in scripts) {
      rv = rv + script.name + "\n";
    }
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scripts'),
        actions: [
          IconButton(
              tooltip: _showGridView ? 'Switch to List View' : 'Switch to Grid View',
              icon: Icon(_showGridView ? Icons.list_sharp : Icons.grid_view),
              onPressed: () => setState(() {
                    _showGridView = !_showGridView;
                  })),
          IconButton(tooltip: 'Add Script', onPressed: () => Navigator.pushNamed(context, ScriptEditScreen.routeNameAdd), icon: const Icon(Icons.add)),
          IconButton(
              color: _selected.length == 1 ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor,
              tooltip: 'Edit Script',
              onPressed: () => _selected.length == 1 ? Navigator.pushNamed(context, ScriptEditScreen.routeNameEdit, arguments: _selected[0].uuid) : null,
              icon: const Icon(Icons.edit)),
          IconButton(
              color: _selected.isEmpty ? Theme.of(context).disabledColor : Theme.of(context).iconTheme.color,
              tooltip: 'Delete Script',
              onPressed: () => _selected.isEmpty
                  ? null
                  : {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete These Scripts?'),
                                content: Text(_scriptsNameList(_selected)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      for (var element in _selected) {
                                        BlocProvider.of<DataStoreBloc>(context).add(ScriptStoreDeleteEvent(uuid: element.uuid));
                                        BlocProvider.of<DataStoreBloc>(context).add(DataStoreSave(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));
                                      }
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ))
                    },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: buildScriptsList(),
    );
  }

  Widget buildScriptsList() {
    return BlocConsumer<DataStoreBloc, DataStoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DataStoreUpdated) {
            return _showGridView ? _gridView(state.scripts) : _listView(state.scripts);
          }
          return _showGridView ? _gridView([]) : _listView([]);
        });
  }

  Widget _listView(List<StoredScript> scripts) {
    return ListView.builder(
        itemCount: scripts.length,
        itemBuilder: (context, index) => ScriptListItem(
            storedScript: scripts[index],
            selectedCallback: (script, selected) {
              setState(() {
                _selected.removeWhere((element) => element.uuid == script.uuid);
                if (selected) {
                  _selected.add(script);
                }
              });
            }));
  }

  Widget _gridView(List<StoredScript> scripts) {
    return Wrap(
      children: scripts
          .map<Widget>((StoredScript script) => ScriptCard(
                storedScript: script,
                selectedCallback: (script, selected) {
                  setState(() {
                    _selected.removeWhere((element) => element.uuid == script.uuid);
                    if (selected) {
                      _selected.add(script);
                    }
                  });
                },
              ))
          .toList(),
    );
  }
}
