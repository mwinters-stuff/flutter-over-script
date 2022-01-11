import 'package:flutter/material.dart';
import 'package:overscript/repositories/stored_script.dart';

typedef SelectedCallback = void Function(StoredScript script, bool selected);

class ScriptCard extends StatefulWidget {
  final StoredScript storedScript;
  final SelectedCallback? selectedCallback;

  const ScriptCard(
      {Key? key, required this.storedScript, this.selectedCallback})
      : super(key: key);

  @override
  _ScriptCardState createState() => _ScriptCardState();
}

class _ScriptCardState extends State<ScriptCard> {
  StoredScript? _script;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _script = widget.storedScript;
    });

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: _checked
              ? Theme.of(context).highlightColor
              : Theme.of(context).colorScheme.surface,
          child: InkWell(
            child: SizedBox(
                width: 200,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(color: Colors.blue.shade700),
                      child: Text(_script!.name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: Colors.white)),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          _script!.command,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        )),
                  ],
                )),
            onTap: () {
              widget.selectedCallback!(_script!, !_checked);
              setState(() {
                _checked = !_checked;
              });
            },
          ),
        ));
  }
}
