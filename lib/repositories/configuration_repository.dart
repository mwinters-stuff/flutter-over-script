import 'dart:ui';

import 'package:overscript/utils/window_preference_adapter.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ConfigurationRepository {
  final Preference<String> scriptPath;
  final Preference<String> sourcePath;
  final Preference<String> editorExecutable;
  final Preference<String> selectedScriptName;
  final Preference<String> selectedBranchName;
  final Preference<bool> useKitty;
  final Preference<Rect> windowRect;
  final Preference<String> scriptDataFile;

  ConfigurationRepository({required StreamingSharedPreferences preferences, required String scriptPath, required String sourcePath})
      : scriptPath = preferences.getString('script-path', defaultValue: scriptPath),
        sourcePath = preferences.getString('source-path', defaultValue: sourcePath),
        editorExecutable = preferences.getString('editor-executable', defaultValue: 'code'),
        selectedScriptName = preferences.getString('selected-script', defaultValue: ''),
        selectedBranchName = preferences.getString('selected-branch', defaultValue: ''),
        useKitty = preferences.getBool('use-kitty', defaultValue: false),
        windowRect = preferences.getCustomValue<Rect>('window', defaultValue: Rect.zero, adapter: WindowPreferenceAdapter.instance),
        scriptDataFile = preferences.getString('script-data-file', defaultValue: 'devscripts.json');
}
