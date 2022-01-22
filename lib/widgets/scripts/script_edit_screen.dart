import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/widgets.dart';

class ScriptEditScreen extends StatefulWidget {
  static const routeNameEdit = '/script-edit';
  static const routeNameAdd = '/script-add';
  final String? editUuid;

  const ScriptEditScreen({Key? key, this.editUuid}) : super(key: key);
  @override
  _ScriptEditScreenState createState() => _ScriptEditScreenState();
}

class _ScriptEditScreenState extends State<ScriptEditScreen> {
  bool _isNew = false;
  StoredScript? _script;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.editUuid != null) {
        _isNew = false;
        _script = RepositoryProvider.of<DataStoreRepository>(context).getScript(widget.editUuid!);
      } else {
        _isNew = true;
        _script = StoredScript.empty();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: _isNew ? const Text('New Script') : const Text('Edit Script'),
        actions: [
          MaterialButton(
            child: const Text("SAVE"),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                if (_isNew) {
                  BlocProvider.of<DataStoreBloc>(context).add(ScriptStoreAddEvent(
                    name: _formKey.currentState?.value['name'],
                    command: _formKey.currentState?.value['command'],
                    workingDirectory: _formKey.currentState?.value['workingDirectory'],
                    args: _formKey.currentState?.value['args'],
                    runInDocker: _formKey.currentState?.value['runInDocker'],
                    envVars: _formKey.currentState?.value['envVars'],
                  ));
                } else {
                  BlocProvider.of<DataStoreBloc>(context).add(ScriptStoreEditEvent(
                    uuid: _script!.uuid,
                    name: _formKey.currentState?.value['name'],
                    command: _formKey.currentState?.value['command'],
                    workingDirectory: _formKey.currentState?.value['workingDirectory'],
                    args: _formKey.currentState?.value['args'],
                    runInDocker: _formKey.currentState?.value['runInDocker'],
                    envVars: _formKey.currentState?.value['envVars'],
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
            },
          )
        ],
      ),
      body: buildBody(context),
    );
  }

  bool autoValidate = true;
  bool readOnly = false;

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              // enabled: false,
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: {
                'name': _script!.name,
                'command': _script!.command,
                'workingDirectory': _script!.workingDirectory,
                'args': _script!.args,
                'args_str': _script!.args.join(" "),
                'runInDocker': _script!.runInDocker,
                'envVars': _script!.envVars
              },
              skipDisabled: true,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'name',
                    decoration: const InputDecoration(
                      labelText: 'Script Name',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'command',

                    decoration: InputDecoration(
                      labelText: 'Command',
                      suffixIcon: IconButton(
                          onPressed: () {
                            _pickExecutable(context, "Select script").then((value) => {_formKey.currentState!.fields['command']!.didChange(value)});
                          },
                          icon: const Icon(Icons.apps_outlined)),
                    ),
                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required(context), validatorFileExists(context, errorText: "Command must exist")]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderStringListEditor(name: 'args', labelText: 'Arguments', autovalidateMode: AutovalidateMode.disabled),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'workingDirectory',

                    decoration: InputDecoration(
                        labelText: 'Working Directory',
                        suffixIcon: IconButton(
                            onPressed: () {
                              _pickDir(context, "Select Working Directory").then((value) => {_formKey.currentState!.fields['workingDirectory']!.didChange(value)});
                            },
                            icon: const Icon(Icons.folder_open))),

                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required(context), validatorDirExists(context, errorText: "Working directory must exist")]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderSwitch(
                    title: const Text('Run in Docker'),
                    name: 'runInDocker',
                  ),
                  FormBuilderStringPairListEditor(name: 'envVars', labelText: 'Environment Variables', autovalidateMode: AutovalidateMode.disabled)
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 16),
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         child: MaterialButton(
            //           color: Theme.of(context).colorScheme.secondary,
            //           onPressed: () {
            //             if (_formKey.currentState?.saveAndValidate() ?? false) {
            //               if (_isNew) {
            //                 BlocProvider.of<DataStoreBloc>(context).add(ScriptStoreAddEvent(
            //                   name: _formKey.currentState?.value['name'],
            //                   command: _formKey.currentState?.value['command'],
            //                   workingDirectory: _formKey.currentState?.value['workingDirectory'],
            //                   args: _formKey.currentState?.value['args'],
            //                   runInDocker: _formKey.currentState?.value['runInDocker'],
            //                   envVars: _formKey.currentState?.value['envVars'],
            //                 ));
            //               } else {
            //                 BlocProvider.of<DataStoreBloc>(context).add(ScriptStoreEditEvent(
            //                   uuid: _script!.uuid,
            //                   name: _formKey.currentState?.value['name'],
            //                   command: _formKey.currentState?.value['command'],
            //                   workingDirectory: _formKey.currentState?.value['workingDirectory'],
            //                   args: _formKey.currentState?.value['args'],
            //                   runInDocker: _formKey.currentState?.value['runInDocker'],
            //                   envVars: _formKey.currentState?.value['envVars'],
            //                 ));
            //               }
            //               BlocProvider.of<DataStoreBloc>(context).add(DataStoreSave(RepositoryProvider.of<ConfigurationRepository>(context).scriptDataFile.getValue()));

            //               debugPrint('validation success');
            //               debugPrint(_formKey.currentState?.value.toString());
            //               Navigator.of(context).pop();
            //             } else {
            //               debugPrint(_formKey.currentState?.value.toString());
            //               debugPrint('validation failed');
            //             }
            //           },
            //           child: const Text(
            //             'Submit',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ),
            //       ),
            // const SizedBox(width: 20),
            // Expanded(
            //   child: OutlinedButton(
            //     onPressed: () {
            //       _formKey.currentState?.reset();
            //     },
            //     // color: Theme.of(context).colorScheme.secondary,
            //     child: Text(
            //       'Reset',
            //       style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      //   ],
      // ),
      // ),
    );
  }

  Future<String?> _pickDir(BuildContext context, String title) async {
    return await getDirectoryPath(confirmButtonText: 'Confirm');
  }

  Future<String?> _pickExecutable(BuildContext context, String title) async {
    final typeGroup = XTypeGroup(label: 'executables', extensions: []);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) {
      // Operation was canceled by the user.
      return null;
    }
    return file.path;
  }

  static FormFieldValidator<String> validatorFileExists(
    BuildContext context, {
    String? errorText,
  }) =>
      (valueCandidate) => true == valueCandidate?.isNotEmpty && !File(valueCandidate!.trim()).existsSync() ? errorText : null;
  static FormFieldValidator<String> validatorDirExists(
    BuildContext context, {
    String? errorText,
  }) =>
      (valueCandidate) => true == valueCandidate?.isNotEmpty && !Directory(valueCandidate!.trim()).existsSync() ? errorText : null;
}
