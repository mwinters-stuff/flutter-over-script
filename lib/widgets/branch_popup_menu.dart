import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';

typedef ChangeFunction = Function(String newValue);

class BranchPopupMenu extends StatefulWidget {
  final String initialValue;
  final ChangeFunction onChanged;

  const BranchPopupMenu(
      {Key? key, required this.initialValue, required this.onChanged})
      : super(key: key);

  @override
  _BranchPopupMenuState createState() => _BranchPopupMenuState();
}

class _BranchPopupMenuState extends State<BranchPopupMenu> {
  Branch? _selection;

  Branch? get selection => _selection;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BranchesBloc>(context).add(BranchesRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BranchesBloc, BranchesState>(
        listener: (context, state) {
      if (state is BranchesLoadedState) {
        setState(() {
          _selection = RepositoryProvider.of<BranchRepository>(context)
              .getBranchFromName(name: widget.initialValue);
        });
      }
    }, builder: (context, state) {
      if (state is BranchesLoadedState) {
        return DropdownButton<Branch>(
            value: _selection,
            isExpanded: true,
            onChanged: (Branch? result) {
              setState(() {
                _selection = result;
                widget.onChanged(result!.name);
                dog.i('branch selected ${result.name}');
              });
            },
            items: getDropdownItems(state));
      } else {
        return const Text('no branches loaded');
      }
    });
  }

  List<DropdownMenuItem<Branch>> getDropdownItems(BranchesLoadedState state) {
    var items = <DropdownMenuItem<Branch>>[];
    for (var element in state.branches) {
      items.add(DropdownMenuItem<Branch>(
          value: element,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(element.name),
            Text(
              element.gitBranch,
              style: Theme.of(context).textTheme.subtitle2,
            )
          ])));
    }
    return items;
  }
}
