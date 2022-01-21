import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:overscript/repositories/repositories.dart';

/// Field for selecting and editing a list of strings.
class FormBuilderBranchVariableList extends FormBuilderField<List<StringPair>> {
  final List<StoredBranch> branchList;

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
  final Widget Function(BuildContext, Widget?)? editorBuilder; // widget.builder,

  final RouteSettings? routeSettings; // widget.routeSettings,
  final String? saveText; // widget.saveText,
  final bool useRootNavigator; // widget.useRootNavigator,
  final String labelText;

  /// Creates field for selecting a range of dates
  FormBuilderBranchVariableList({
    Key? key,
    //From Super
    required String name,
    required this.labelText,
    required this.branchList,
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
            final state = field as _FormBuilderBranchVariableListState;
            return SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  Expanded(child: ListView(children: [for (var branch in branchList) _listItem(branch, field.value)]))
                ]));

            // return TextField(
            //     enabled: state.enabled,
            //     style: style,
            //     focusNode: state.effectiveFocusNode,
            //     decoration: state._decoration,
            //     maxLines: 1,
            //     keyboardType: keyboardType,
            //     obscureText: obscureText,
            //     onEditingComplete: onEditingComplete,
            //     controller: state._effectiveController,
            //     autocorrect: autocorrect,
            //     autofocus: autofocus,
            //     buildCounter: buildCounter,
            //     cursorColor: cursorColor,
            //     cursorRadius: cursorRadius,
            //     cursorWidth: cursorWidth,
            //     enableInteractiveSelection: enableInteractiveSelection,
            //     maxLength: maxLength,
            //     inputFormatters: inputFormatters,
            //     keyboardAppearance: keyboardAppearance,
            //     maxLengthEnforcement: maxLengthEnforcement,
            //     scrollPadding: scrollPadding,
            //     textAlign: textAlign,
            //     textCapitalization: textCapitalization,
            //     textDirection: textDirection,
            //     textInputAction: textInputAction,
            //     strutStyle: strutStyle,
            //     readOnly: true,
            //     expands: expands,
            //     minLines: 1,
            //     showCursor: showCursor);
          },
        );

  @override
  _FormBuilderBranchVariableListState createState() => _FormBuilderBranchVariableListState();

  static _listItem(StoredBranch branch, List<StringPair>? value) {
    StringPair pair = value!.firstWhere((element) => element.value1 == branch.uuid, orElse: () => StringPair(branch.uuid, ""));
    return _ListTile(branch: branch, value: pair);
  }
}

class _FormBuilderBranchVariableListState extends FormBuilderFieldState<FormBuilderBranchVariableList, List<StringPair>> {
  // @override
  // void initState() {
  //   super.initState();
  //   _effectiveController = widget.controller ?? TextEditingController(text: _valueToText());
  // }

  // @override
  // void dispose() {
  //   // Dispose the _effectiveController when initState created it
  //   if (null == widget.controller) {
  //     _effectiveController.dispose();
  //   }
  //   super.dispose();
  // }

  // String _valueToText() {
  //   if (value == null) {
  //     return '';
  //   }

  //   return value!.join(' ');
  // }

  // void _setTextFieldString() {
  //   setState(() => _effectiveController.text = _valueToText());
  // }

  // @override
  // void didChange(List<StringPair>? value) {
  //   super.didChange(value);
  //   _setTextFieldString();
  // }

  // @override
  // void reset() {
  //   super.reset();
  //   _setTextFieldString();
  // }
}

class _ListTile extends StatefulWidget {
  const _ListTile({
    Key? key,
    required this.branch,
    required this.value,
  }) : super(key: key);

  final StoredBranch branch;
  final StringPair value;

  @override
  State<_ListTile> createState() => _ListTileState();
}

class _ListTileState extends State<_ListTile> {
  late TextEditingController _controller;
  late StoredBranch _branch;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _branch = widget.branch;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.value.value1;

    return Row(children: [
      Expanded(
          child: Row(children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(_branch.name),
        )),
        const Padding(padding: EdgeInsets.all(8), child: Text("=")),
        Expanded(
            child: Focus(
                autofocus: true,
                // onFocusChange: (value) => setState(() {
                //       if (!value) {
                //         widget.onSubmitted(StringPair(_controller1.text, _controller2.text));
                //       }
                //     }),
                child: TextField(
                  controller: _controller,
                )))
      ])),
    ]);
  }
}
