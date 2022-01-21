import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/scripts/script_edit_screen.dart';

typedef ScriptListItemSelectedCallback = void Function(StoredScript script, bool selected);

class ScriptListItem extends StatefulWidget {
  final StoredScript storedScript;
  final ScriptListItemSelectedCallback? selectedCallback;

  const ScriptListItem({Key? key, required this.storedScript, this.selectedCallback}) : super(key: key);

  @override
  _ScriptListItemState createState() => _ScriptListItemState();
}

class _ScriptListItemState extends State<ScriptListItem> {
  late StoredScript _script;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _script = widget.storedScript;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          color: _checked ? Theme.of(context).highlightColor : Theme.of(context).colorScheme.surface,
          child: InkWell(
            child: ListTile(
              title: Text(_script.name),
              subtitle: Text(_script.command + " " + _script.args.join(" ") + "\n" + _script.workingDirectory),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(tooltip: 'Edit Script', onPressed: () => Navigator.pushNamed(context, ScriptEditScreen.routeNameEdit, arguments: _script.uuid), icon: const Icon(Icons.edit)),
                  IconButton(
                      tooltip: 'Delete Script',
                      onPressed: () => {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Delete Script?'),
                                      content: Text(_script.name),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                            BlocProvider.of<DataStoreBloc>(context).add(ScriptStoreDeleteEvent(uuid: _script.uuid));
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
            ),
            onTap: () {
              widget.selectedCallback!(_script, !_checked);
              setState(() {
                _checked = !_checked;
              });
            },
          ),
        ));
  }
}
