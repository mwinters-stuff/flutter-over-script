import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/variables/form_branch_variable_list.dart';

class VariableEditScreen extends StatefulWidget {
  static const routeNameEdit = '/variable-edit';
  static const routeNameAdd = '/variable-add';
  final String? editUuid;

  const VariableEditScreen({Key? key, this.editUuid}) : super(key: key);
  @override
  _VariableEditScreenState createState() => _VariableEditScreenState();
}

class _VariableEditScreenState extends State<VariableEditScreen> {
  bool _isNew = false;
  StoredVariable? _variable;
  List<StoredBranch>? _branches;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _branches = RepositoryProvider.of<DataStoreRepository>(context).branches;
      if (widget.editUuid != null) {
        _isNew = false;
        _variable = RepositoryProvider.of<DataStoreRepository>(context).getVariable(widget.editUuid!);
      } else {
        _isNew = true;
        _variable = const StoredVariable.empty();
      }
    });
    return Scaffold(
      appBar: AppBar(title: _isNew ? const Text('New Variable') : const Text('Edit Variable'), actions: [
        MaterialButton(
            child: const Text("SAVE"),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                var branchValues = <StringPair>[];

                for (StoredBranch sb in _branches ?? []) {
                  branchValues.add(StringPair(sb.uuid, _formKey.currentState?.value[sb.uuid]));
                }

                if (_isNew) {
                  BlocProvider.of<DataStoreBloc>(context).add(VariableStoreAddEvent(
                    name: _formKey.currentState?.value['name'],
                    branchValues: branchValues,
                  ));
                } else {
                  BlocProvider.of<DataStoreBloc>(context).add(VariableStoreEditEvent(
                    uuid: _variable!.uuid,
                    name: _formKey.currentState?.value['name'],
                    branchValues: branchValues,
                  ));
                }
                BlocProvider.of<DataStoreBloc>(context).add(DataStoreSave(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));

                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Validation Failed'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            })
      ]),
      body: buildBody(context),
    );
  }

  bool autoValidate = true;
  bool readOnly = false;

  Widget buildBody(BuildContext context) {
    var initialValues = {'name': _variable!.name};
    for (StoredBranch sb in _branches ?? []) {
      initialValues.putIfAbsent(sb.uuid, () => _variable!.branchValues.firstWhere((element) => sb.uuid == element.value1, orElse: () => const StringPair("", "")).value2);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              // enabled: false,
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: initialValues,
              skipDisabled: true,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'name',
                    decoration: const InputDecoration(
                      labelText: 'Variable Name',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  for (StoredBranch branch in _branches ?? [])
                    FormBuilderTextField(
                      name: branch.uuid,
                      decoration: InputDecoration(
                        labelText: "Branch: ${branch.name}",
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _pickDir(BuildContext context, String title) async {
    return await getDirectoryPath(confirmButtonText: 'Confirm');
  }

  static FormFieldValidator<String> validatorDirExists(
    BuildContext context, {
    String? errorText,
  }) =>
      (valueCandidate) => true == valueCandidate?.isNotEmpty && !Directory(valueCandidate!.trim()).existsSync() ? errorText : null;
}
