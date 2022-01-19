import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/settings_screen.dart';
import 'package:overscript/widgets/widgets.dart';
import 'dart:io' show Platform;
import 'package:path/path.dart' as p;
import 'package:args/args.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:dog/dog.dart';
import 'package:window_size/window_size.dart';

Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();

  var parser = ArgParser();
  parser.addOption('script-path', abbr: 't', help: 'path to where the scripts are', defaultsTo: p.dirname(Platform.resolvedExecutable));
  parser.addOption('source-path', abbr: 's', help: 'path to where the source is rooted', defaultsTo: p.join(Platform.environment['HOME']!, 'src'));

  parser.addFlag('help', abbr: 'h', defaultsTo: false);

  var args = parser.parse(arguments);

  if (args['help']) {
    dog.i(parser.usage);
    return;
  }

  final scriptPath = args['script-path'];
  final sourcePath = args['source-path'];
  final preferences = await StreamingSharedPreferences.instance;

  var configurationRepository = ConfigurationRepository(preferences: preferences, scriptPath: scriptPath, sourcePath: sourcePath);

  runApp(MultiRepositoryProvider(providers: [
    RepositoryProvider<ConfigurationRepository>(create: (context) => configurationRepository),
    RepositoryProvider<OldScriptsRepository>(create: (context) => OldScriptsRepository(context)),
    RepositoryProvider<BranchRepository>(create: (context) => BranchRepository()),
    RepositoryProvider<PtyRepository>(create: (context) => PtyRepository()),
    RepositoryProvider<KittyRepository>(create: (context) => KittyRepository()),
    RepositoryProvider<DataStoreRepository>(create: (context) => DataStoreRepository()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowRect = RepositoryProvider.of<ConfigurationRepository>(context).windowRect.getValue();
    if (!windowRect.isEmpty) {
      setWindowFrame(windowRect);
    }
    setWindowTitle('Overscript');

    // Timer.periodic(
    //     const Duration(seconds: 10),
    //     (_) => getWindowInfo().then((windowPrefs) =>
    //         RepositoryProvider.of<ConfigurationRepository>(context)
    //             .windowRect
    //             .setValue(windowPrefs.frame)));
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConfigurationBloc>(create: (context) => ConfigurationBloc(configurationRepository: RepositoryProvider.of<ConfigurationRepository>(context))),
        BlocProvider<OldScriptsBloc>(
            create: (context) =>
                OldScriptsBloc(scriptsRepository: RepositoryProvider.of<OldScriptsRepository>(context), configurationRepository: RepositoryProvider.of<ConfigurationRepository>(context))),
        BlocProvider<BranchesBloc>(create: (context) => BranchesBloc(context, branchesRepository: RepositoryProvider.of<BranchRepository>(context))),
        BlocProvider<PtyBloc>(create: (context) => PtyBloc(repository: RepositoryProvider.of<PtyRepository>(context))),
        BlocProvider<KittyBloc>(create: (context) => KittyBloc(repository: RepositoryProvider.of<KittyRepository>(context))),
        BlocProvider<DataStoreBloc>(create: (context) => DataStoreBloc(repository: RepositoryProvider.of<DataStoreRepository>(context)))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Overscript',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case SettingsScreen.routeName:
                return MaterialPageRoute(builder: (BuildContext context) => const SettingsScreen());
              case ScriptsScreen.routeName:
                return MaterialPageRoute(builder: (BuildContext context) => const ScriptsScreen());
              case ScriptEditScreen.routeNameAdd:
                return MaterialPageRoute(builder: (BuildContext context) => const ScriptEditScreen());
              case ScriptEditScreen.routeNameEdit:
                return MaterialPageRoute(builder: (BuildContext context) => ScriptEditScreen(editUuid: settings.arguments as String));
              default:
                return MaterialPageRoute(builder: (BuildContext context) => const AppScaffold(title: 'Overscript'));
            }
          },
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ]),
    );
  }
}
