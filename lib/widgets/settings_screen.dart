import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConfigurationBloc>(context)
        .add(ConfigurationRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return BlocConsumer<ConfigurationBloc, ConfigurationState>(
        listener: (context, state) {
      if (state is ConfigurationChangedState) {
        BlocProvider.of<ConfigurationBloc>(context)
            .add(ConfigurationRequestEvent());
      }
    }, builder: (context, state) {
      if (state is ConfigurationLoadedState) {
        return SettingsList(
          sections: [
            SettingsSection(
              title: 'Paths',
              tiles: [
                SettingsTile(
                  title: 'Scripts',
                  subtitle: state.scriptPath.getValue(),
                  leading: const Icon(Icons.folder),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (context) {
                    _pickDir(context, 'Scripts Path').then((value) {
                      if (value != null) {
                        state.scriptPath.setValue(value);
                        BlocProvider.of<ConfigurationBloc>(context)
                            .add(ConfigurationChangedEvent());
                      }
                    });
                  },
                ),
                SettingsTile(
                  title: 'Source Path',
                  subtitle: state.sourcePath.getValue(),
                  leading: const Icon(Icons.folder),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (context) {
                    _pickDir(context, 'Source Path').then((value) {
                      if (value != null) {
                        state.sourcePath.setValue(value);
                        BlocProvider.of<ConfigurationBloc>(context)
                            .add(ConfigurationChangedEvent());
                      }
                    });
                  },
                ),
                SettingsTile(
                  title: 'Editor',
                  subtitle: state.editorExecutable.getValue(),
                  leading: const Icon(Icons.folder),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (context) {
                    _pickExecutable(context, 'Editor Executable').then((value) {
                      if (value != null) {
                        state.editorExecutable.setValue(value);
                        BlocProvider.of<ConfigurationBloc>(context)
                            .add(ConfigurationChangedEvent());
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Future<String?> _pickDir(BuildContext context, String title) async {
    return await getDirectoryPath(confirmButtonText: 'Confirm');
    // return await FilesystemPicker.open(
    //   title: title,
    //   context: context,
    //   rootDirectory: Directory(Platform.environment['HOME']!),
    //   fsType: FilesystemType.folder,
    //   pickText: 'Use this folder',
    //   folderIconColor: Colors.teal,
    //   // requestPermission: () async =>
    //   //     await Permission.storage.request().isGranted,
    // );
  }

  Future<String?> _pickExecutable(BuildContext context, String title) async {
    final typeGroup = XTypeGroup(label: 'executables', extensions: []);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) {
      // Operation was canceled by the user.
      return null;
    }
    return file.name;
    // return await FilesystemPicker.open(
    //   title: title,
    //   context: context,
    //   rootDirectory: Directory(Platform.environment['HOME']!),
    //   fsType: FilesystemType.file,
    //   pickText: 'Select Executable',
    //   folderIconColor: Colors.teal,
    //   // requestPermission: () async =>
    //   //     await Permission.storage.request().isGranted,
    // );
  }
}
