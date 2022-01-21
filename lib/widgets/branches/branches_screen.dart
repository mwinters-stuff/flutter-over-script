import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/branches/branch_edit_screen.dart';
import 'package:overscript/widgets/branches/branch_list_item.dart';

class BranchesScreen extends StatefulWidget {
  static const routeName = '/branches';

  const BranchesScreen({Key? key}) : super(key: key);
  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final List<StoredBranch> _selected = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DataStoreBloc>(context).add(DataStoreLoad(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));
  }

  String _branchesNameList(List<StoredBranch> branches) {
    String rv = "";
    for (var script in branches) {
      rv = rv + script.name + "\n";
    }
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
        actions: [
          IconButton(tooltip: 'Add Branch', onPressed: () => Navigator.pushNamed(context, BranchEditScreen.routeNameAdd), icon: const Icon(Icons.add)),
          IconButton(
              color: _selected.length == 1 ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor,
              tooltip: 'Edit Branch',
              onPressed: () => _selected.length == 1 ? Navigator.pushNamed(context, BranchEditScreen.routeNameEdit, arguments: _selected[0].uuid) : null,
              icon: const Icon(Icons.edit)),
          IconButton(
              color: _selected.isEmpty ? Theme.of(context).disabledColor : Theme.of(context).iconTheme.color,
              tooltip: 'Delete Branch',
              onPressed: () => _selected.isEmpty
                  ? null
                  : {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete These Branches?'),
                                content: Text(_branchesNameList(_selected)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      for (var element in _selected) {
                                        BlocProvider.of<DataStoreBloc>(context).add(BranchStoreDeleteEvent(uuid: element.uuid));
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
      body: buildBranchesList(),
    );
  }

  Widget buildBranchesList() {
    return BlocConsumer<DataStoreBloc, DataStoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DataStoreUpdated) {
            return _listView(state.branches);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _listView(List<StoredBranch> branches) {
    return ListView.builder(
        itemCount: branches.length,
        itemBuilder: (context, index) => BranchListItem(
            storedBranch: branches[index],
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
