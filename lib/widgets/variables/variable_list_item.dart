import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/variables/variable_edit_screen.dart';

typedef VariableListItemSelectedCallback = void Function(StoredVariable variable, bool selected);

class VariableListItem extends StatefulWidget {
  final StoredVariable storedVariable;
  final VariableListItemSelectedCallback? selectedCallback;
  final List<StoredBranch> storedBranches;

  const VariableListItem({Key? key, required this.storedVariable, required this.storedBranches, this.selectedCallback}) : super(key: key);

  @override
  _VariableListItemState createState() => _VariableListItemState();
}

class _VariableListItemState extends State<VariableListItem> {
  late StoredVariable _variable;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _variable = widget.storedVariable;
    });
  }

  String _branchValuesList(List<StringPair> strings) {
    String rv = '';
    for (var pair in strings) {
      var branchName = widget.storedBranches.firstWhere((element) => pair.value1 == element.uuid).name;
      rv = rv + branchName + " = " + pair.value2 + "\n";
    }
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          color: _checked ? Theme.of(context).highlightColor : Theme.of(context).colorScheme.surface,
          child: InkWell(
            child: ListTile(
              title: Text(_variable.name),
              subtitle: Text(_branchValuesList(_variable.branchValues)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(tooltip: 'Edit Variable', onPressed: () => Navigator.pushNamed(context, VariableEditScreen.routeNameEdit, arguments: _variable.uuid), icon: const Icon(Icons.edit)),
                  IconButton(
                      tooltip: 'Delete Variable',
                      onPressed: () => {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Delete Branch?'),
                                      content: Text(_variable.name),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                            BlocProvider.of<DataStoreBloc>(context).add(VariableStoreDeleteEvent(uuid: _variable.uuid));
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
              widget.selectedCallback!(_variable, !_checked);
              setState(() {
                _checked = !_checked;
              });
            },
          ),
        ));
  }
}
