part of 'pty_bloc.dart';

@immutable
abstract class PtyState extends Equatable {
  final List<Terminal> terminals;
  const PtyState({this.terminals = const <Terminal>[]});
  @override
  List<Object> get props => [terminals];

  List<Tab> getTabs({required BuildContext context}) {
    final result = <Tab>[];
    for (var element in terminals) {
      result.add(Tab(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
            child: Text((element.backend as PtyTerminalTabBackend).tabTitle,
                overflow: TextOverflow.clip)),
        IconButton(
            onPressed: () {
              BlocProvider.of<PtyBloc>(context).add(PtyRemoveEvent(
                  uuid: (element.backend as PtyTerminalTabBackend).uuid));
            },
            icon: const Icon(Icons.close))
      ])));
    }

    return result;
  }

  List<Widget> getTabViews() {
    final result = <TerminalView>[];
    for (var element in terminals) {
      result.add(
        TerminalView(
          terminal: element,
          autofocus: false,
          style: const TerminalStyle(fontFamily: ['Fira Code']),
        ),
      );
    }

    return result;
  }
}

class PtyInitialState extends PtyState {}

class PtyAddingTerminalState extends PtyState {
  final String tabTitle;
  final List<String> commands;
  final String workingDirectory;

  const PtyAddingTerminalState(
      {required terminals,
      required this.tabTitle,
      required this.commands,
      required this.workingDirectory})
      : super(terminals: terminals);
}

class PtyRemovingTerminalState extends PtyState {
  const PtyRemovingTerminalState({required terminals})
      : super(terminals: terminals);
}

class PtyTerminalsState extends PtyState {
  const PtyTerminalsState({required terminals}) : super(terminals: terminals);
}
