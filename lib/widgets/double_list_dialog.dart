import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:overscript/repositories/repositories.dart';

import 'custom_alert_dialog.dart';

/// Field for selecting and editing a list of string pairs stored in a map.
class FormBuilderStringPairListEditor
    extends FormBuilderField<List<StringPair>> {
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextStyle? style;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final bool autofocus;
  final bool autocorrect;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final ValueChanged<DateTimeRange?>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  final bool expands;
  final bool showCursor;
  final Widget Function(BuildContext, Widget?)?
      editorBuilder; // widget.builder,

  final RouteSettings? routeSettings; // widget.routeSettings,
  final String? saveText; // widget.saveText,
  final bool useRootNavigator; // widget.useRootNavigator,
  final String labelText;

  /// Creates field for selecting a range of dates
  FormBuilderStringPairListEditor({
    Key? key,
    //From Super
    required String name,
    required this.labelText,
    FormFieldValidator<List<StringPair>>? validator,
    List<StringPair>? initialValue,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<List<StringPair>?>? onChanged,
    ValueTransformer<List<StringPair>?>? valueTransformer,
    bool enabled = true,
    FormFieldSetter<List<StringPair>>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    VoidCallback? onReset,
    FocusNode? focusNode,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
    this.cursorWidth = 2.0,
    this.keyboardType,
    this.style,
    this.controller,
    this.textInputAction,
    this.strutStyle,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.buildCounter,
    this.expands = false,
    this.showCursor = false,
    this.editorBuilder,
    this.routeSettings,
    this.saveText,
    this.useRootNavigator = true,
  }) : super(
          key: key,
          initialValue: initialValue,
          name: name,
          validator: validator,
          valueTransformer: valueTransformer,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          onSaved: onSaved,
          enabled: enabled,
          onReset: onReset,
          decoration: decoration,
          focusNode: focusNode,
          builder: (FormFieldState<List<StringPair>?> field) {
            final state = field as _FormBuilderStringPairListEditorState;
            return TextField(
                enabled: state.enabled,
                style: style,
                focusNode: state.effectiveFocusNode,
                decoration: state._decoration,
                maxLines: 1,
                keyboardType: keyboardType,
                obscureText: obscureText,
                onEditingComplete: onEditingComplete,
                controller: state._effectiveController,
                autocorrect: autocorrect,
                autofocus: autofocus,
                buildCounter: buildCounter,
                cursorColor: cursorColor,
                cursorRadius: cursorRadius,
                cursorWidth: cursorWidth,
                enableInteractiveSelection: enableInteractiveSelection,
                maxLength: maxLength,
                inputFormatters: inputFormatters,
                keyboardAppearance: keyboardAppearance,
                maxLengthEnforcement: maxLengthEnforcement,
                scrollPadding: scrollPadding,
                textAlign: textAlign,
                textCapitalization: textCapitalization,
                textDirection: textDirection,
                textInputAction: textInputAction,
                strutStyle: strutStyle,
                readOnly: true,
                expands: expands,
                minLines: 1,
                showCursor: showCursor);
          },
        );

  @override
  _FormBuilderStringPairListEditorState createState() =>
      _FormBuilderStringPairListEditorState();
}

class _FormBuilderStringPairListEditorState extends FormBuilderFieldState<
    FormBuilderStringPairListEditor, List<StringPair>> {
  late TextEditingController _effectiveController;

  InputDecoration get _decoration => widget.decoration.copyWith(
      label: Text(widget.labelText),
      suffixIcon: IconButton(
          onPressed: () => handleTap(), icon: const Icon(Icons.list)));

  @override
  void initState() {
    super.initState();
    _effectiveController =
        widget.controller ?? TextEditingController(text: _valueToText());
  }

  @override
  void dispose() {
    // Dispose the _effectiveController when initState created it
    if (null == widget.controller) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  Future<void> handleTap() async {
    if (enabled) {
      final picked = await _showDialog(
        context,
        widget.labelText,
        value ?? [],
      );
      if (picked != null && picked is List) {
        didChange(List<StringPair>.from(picked));
      }
    }
  }

  String _valueToText() {
    if (value == null) {
      return '';
    }

    return value!.join(" ");
  }

  void _setTextFieldString() {
    setState(() => _effectiveController.text = _valueToText());
  }

  @override
  void didChange(List<StringPair>? value) {
    super.didChange(value);
    _setTextFieldString();
  }

  @override
  void reset() {
    super.reset();
    _setTextFieldString();
  }
}

typedef _AddItem = void Function();

class _OnAddItemEvent {
  _AddItem? addItemFunc;
  void addItem() => addItemFunc!();
}

Future _showDialog(
    BuildContext context, String title, List<StringPair> items) async {
  final addItemEvent = _OnAddItemEvent();

  final listView =
      _ArgumentsListView(items: List.from(items), onAddItemEvent: addItemEvent);
  return showDialog(
    context: context,
    builder: (context) => CustomAlertDialog(
      title: Text(title, style: DialogTheme.of(context).titleTextStyle),
      content: SizedBox(
          width: double.maxFinite, //  <------- Use SizedBox to limit width
          child: listView),
      actions: [
        Expanded(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextButton(
            onPressed: () => addItemEvent.addItem(),
            child: const Text('Add'),
          ),
        ])),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
                context,
                List.from(listView.items
                    .where((element) => element.value1.isNotEmpty)));
          },
          child: const Text('OK'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.all(8),
    ),
  );
}

class _ArgumentsListView extends StatefulWidget {
  const _ArgumentsListView(
      {Key? key, required this.items, required this.onAddItemEvent})
      : super(key: key);

  final List<StringPair> items;
  final _OnAddItemEvent onAddItemEvent;

  @override
  State<_ArgumentsListView> createState() => _ArgumentsListViewState();
}

class _ArgumentsListViewState extends State<_ArgumentsListView> {
  @override
  void initState() {
    super.initState();
    widget.onAddItemEvent.addItemFunc = () => setState(() {
          widget.items.add(const StringPair('', ''));
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.onAddItemEvent.addItemFunc = null;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: widget.items.length,
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      itemBuilder: (BuildContext context, int index) {
        return _ArgumentListTile(
            key: Key('$index'),
            index: index,
            value: widget.items[index],
            onSubmitted: (value) => setState(() {
                  widget.items[index] = value;
                }),
            onRemove: (index) => setState(() {
                  widget.items.removeAt(index);
                }));
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = widget.items.removeAt(oldIndex);
          widget.items.insert(newIndex, item);
        });
      },
    );
  }

  // void addItem() {
  //   setState(() {
  //     widget.items.add('');
  //   });
  // }
}

typedef _OnSubmitted = void Function(StringPair value);
typedef _OnRemove = void Function(int index);

class _ArgumentListTile extends StatefulWidget {
  const _ArgumentListTile(
      {Key? key,
      required this.index,
      required this.value,
      required this.onSubmitted,
      required this.onRemove})
      : super(key: key);

  final int index;
  final StringPair value;
  final _OnSubmitted onSubmitted;
  final _OnRemove onRemove;

  @override
  State<_ArgumentListTile> createState() => _ArgumentListTileState();
}

class _ArgumentListTileState extends State<_ArgumentListTile> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller1.text = widget.value.value1;
    _controller2.text = widget.value.value2;
    return Row(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: ReorderableDragStartListener(
          index: widget.index,
          child: IconButton(
            icon: const Icon(Icons.drag_handle),
            onPressed: () => {},
          ),
        ),
      ),
      Expanded(
          child: Row(children: [
        Expanded(
            child: Focus(
                autofocus: true,
                onFocusChange: (value) => setState(() {
                      if (!value) {
                        widget.onSubmitted(
                            StringPair(_controller1.text, _controller2.text));
                      }
                    }),
                child: TextField(
                  controller: _controller1,
                ))),
        const Padding(padding: EdgeInsets.all(8), child: Text("=")),
        Expanded(
            child: Focus(
                autofocus: true,
                onFocusChange: (value) => setState(() {
                      if (!value) {
                        widget.onSubmitted(
                            StringPair(_controller1.text, _controller2.text));
                      }
                    }),
                child: TextField(
                  controller: _controller2,
                )))
      ])),
      Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => widget.onRemove(widget.index)))
    ]);
  }
}
