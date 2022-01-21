import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/variables/variable_edit_screen.dart';
import 'package:overscript/widgets/variables/variable_list_item.dart';

class VariablesScreen extends StatefulWidget {
  static const routeName = '/variables';

  const VariablesScreen({Key? key}) : super(key: key);
  @override
  _VariablesScreenState createState() => _VariablesScreenState();
}

class _VariablesScreenState extends State<VariablesScreen> {
  final List<StoredVariable> _selected = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DataStoreBloc>(context).add(DataStoreLoad(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));
  }

  String _variablesNameList(List<StoredVariable> variables) {
    String rv = "";
    for (var script in variables) {
      rv = rv + script.name + "\n";
    }
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Variables'),
        actions: [
          IconButton(tooltip: 'Add Variable', onPressed: () => Navigator.pushNamed(context, VariableEditScreen.routeNameAdd), icon: const Icon(Icons.add)),
          IconButton(
              color: _selected.length == 1 ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor,
              tooltip: 'Edit Variable',
              onPressed: () => _selected.length == 1 ? Navigator.pushNamed(context, VariableEditScreen.routeNameEdit, arguments: _selected[0].uuid) : null,
              icon: const Icon(Icons.edit)),
          IconButton(
              color: _selected.isEmpty ? Theme.of(context).disabledColor : Theme.of(context).iconTheme.color,
              tooltip: 'Delete Variable',
              onPressed: () => _selected.isEmpty
                  ? null
                  : {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete These Variables?'),
                                content: Text(_variablesNameList(_selected)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      for (var element in _selected) {
                                        BlocProvider.of<DataStoreBloc>(context).add(VariableStoreDeleteEvent(uuid: element.uuid));
                                      }
                                      BlocProvider.of<DataStoreBloc>(context).add(DataStoreSave(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ))
                    },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: buildVariablesList(),
    );
  }

  Widget buildVariablesList() {
    return BlocConsumer<DataStoreBloc, DataStoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DataStoreUpdated) {
            return _listView(state.variables);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _listView(List<StoredVariable> variables) {
    return ListView.builder(
        itemCount: variables.length,
        itemBuilder: (context, index) => VariableListItem(
            storedVariable: variables[index],
            selectedCallback: (script, selected) {
              setState(() {
                _selected.removeWhere((element) => element.uuid == script.uuid);
                if (selected) {
                  _selected.add(script);
                }
              });
            }));
  }
}
