import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/branches/branch_edit_screen.dart';
// import 'package:overscript/widgets/branches/branche_edit_screen.dart';

typedef BranchListItemSelectedCallback = void Function(StoredBranch script, bool selected);

class BranchListItem extends StatefulWidget {
  final StoredBranch storedBranch;
  final BranchListItemSelectedCallback? selectedCallback;

  const BranchListItem({Key? key, required this.storedBranch, this.selectedCallback}) : super(key: key);

  @override
  _BranchListItemState createState() => _BranchListItemState();
}

class _BranchListItemState extends State<BranchListItem> {
  late StoredBranch _script;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _script = widget.storedBranch;
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
              title: Text(_script.name),
              subtitle: Text(_script.directory),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(tooltip: 'Edit Branch', onPressed: () => Navigator.pushNamed(context, BranchEditScreen.routeNameEdit, arguments: _script.uuid), icon: const Icon(Icons.edit)),
                  IconButton(
                      tooltip: 'Delete Branch',
                      onPressed: () => {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Delete Branch?'),
                                      content: Text(_script.name),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                            BlocProvider.of<DataStoreBloc>(context).add(BranchStoreDeleteEvent(uuid: _script.uuid));
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
