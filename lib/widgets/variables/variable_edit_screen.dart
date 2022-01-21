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
      appBar: AppBar(title: _isNew ? const Text('New Variable') : const Text('Edit Variable')),
      body: buildBody(context),
    );
  }

  bool autoValidate = true;
  bool readOnly = false;

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              // enabled: false,
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: {
                'name': _variable!.name,
                'branchValues': _variable!.branchValues,
              },
              skipDisabled: true,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 15),
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

                  // FormBuilderTextField(
                  //   autovalidateMode: AutovalidateMode.always,
                  //   name: 'directory',

                  //   decoration: InputDecoration(
                  //       labelText: 'Directory',
                  //       suffixIcon: IconButton(
                  //           onPressed: () {
                  //             _pickDir(context, "Select Branch Directory").then((value) => {_formKey.currentState!.fields['directory']!.didChange(value)});
                  //           },
                  //           icon: const Icon(Icons.folder_open))),

                  //   // valueTransformer: (text) => num.tryParse(text),
                  //   validator: FormBuilderValidators.compose([FormBuilderValidators.required(context), validatorDirExists(context, errorText: "Branch directory must exist")]),
                  //   keyboardType: TextInputType.text,
                  //   textInputAction: TextInputAction.next,
                  // ),
                  FormBuilderBranchVariableList(
                    name: 'branchValues', labelText: "Branch Values",
                    branchList: _branches ?? [],
                    //   decoration: InputDecoration(
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          if (_isNew) {
                            BlocProvider.of<DataStoreBloc>(context).add(VariableStoreAddEvent(
                              name: _formKey.currentState?.value['name'],
                              branchValues: _formKey.currentState?.value['branchValues'],
                            ));
                          } else {
                            BlocProvider.of<DataStoreBloc>(context).add(VariableStoreEditEvent(
                              uuid: _variable!.uuid,
                              name: _formKey.currentState?.value['name'],
                              branchValues: _formKey.currentState?.value['branchValues'],
                            ));
                          }
                          BlocProvider.of<DataStoreBloc>(context).add(DataStoreSave(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));

                          debugPrint('validation success');
                          debugPrint(_formKey.currentState?.value.toString());
                          Navigator.of(context).pop();
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
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
