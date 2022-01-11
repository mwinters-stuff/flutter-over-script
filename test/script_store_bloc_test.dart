import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'script_store_bloc_test.mocks.dart';

@GenerateMocks([ScriptsStoreRepository])
void main() {
  group('ScriptStoreBloc', () {
    late ScriptsStoreBloc scriptsStoreBloc;

    final storedScript = StoredScript(
        uuid: 'uuid',
        name: 'Test Script',
        command: 'test.sh',
        args: ['arg1', 'arg2', 'arg3'],
        workingDirectory: '/workDir',
        runInDocker: false,
        envVars: {"thing": "bob", "which": "that"});

    MockScriptsStoreRepository _mockRepository = MockScriptsStoreRepository();

    setUp(() {
      scriptsStoreBloc = ScriptsStoreBloc(repository: _mockRepository);
    });

    blocTest<ScriptsStoreBloc, ScriptsStoreState>(
      'Loads the script store',
      build: () {
        when(_mockRepository.scripts).thenReturn(<StoredScript>[]);
        return scriptsStoreBloc;
      },
      act: (bloc) => bloc.add(const ScriptStoreLoad('test.json')),
      expect: () => [const ScriptsStoreUpdated(<StoredScript>[])],
      verify: (bloc) => verify(_mockRepository.load('test.json')).called(1),
    );

    blocTest<ScriptsStoreBloc, ScriptsStoreState>(
      'Saves the script store',
      build: () {
        when(_mockRepository.scripts).thenReturn(<StoredScript>[]);
        return scriptsStoreBloc;
      },
      act: (bloc) => bloc.add(const ScriptStoreSave('test.json')),
      expect: () => [const ScriptsStoreUpdated(<StoredScript>[])],
      verify: (bloc) => verify(_mockRepository.save('test.json')).called(1),
    );

    blocTest<ScriptsStoreBloc, ScriptsStoreState>(
      'Adds script to store.',
      build: () {
        when(_mockRepository.scripts).thenReturn(<StoredScript>[storedScript]);
        return scriptsStoreBloc;
      },
      act: (bloc) => bloc.add(const ScriptStoreAdd(
          'Test Script',
          'test.sh',
          ['arg1', 'arg2', 'arg3'],
          '/workDir',
          false,
          {"thing": "bob", "which": "that"})),
      expect: () => [
        ScriptsStoreUpdated(<StoredScript>[storedScript]),
      ],
      verify: (bloc) => verify(_mockRepository.add(
          uuid: argThat(isNotEmpty, named: 'uuid'),
          name: 'Test Script',
          command: 'test.sh',
          args: ['arg1', 'arg2', 'arg3'],
          workingDirectory: '/workDir',
          runInDocker: false,
          envVars: {"thing": "bob", "which": "that"})).called(1),
    );

    blocTest<ScriptsStoreBloc, ScriptsStoreState>('Edits script in store.',
        build: () {
          when(_mockRepository.scripts)
              .thenReturn(<StoredScript>[storedScript]);
          return scriptsStoreBloc;
        },
        act: (bloc) => bloc.add(const ScriptStoreEdit(
            'uuid',
            'Test Script',
            'test.sh',
            ['arg1', 'arg2', 'arg3'],
            '/workDir',
            false,
            {"thing": "bob", "which": "that"})),
        expect: () => [
              ScriptsStoreUpdated(<StoredScript>[storedScript])
            ],
        verify: (bloc) => verify(_mockRepository.edit(
            uuid: 'uuid',
            name: 'Test Script',
            command: 'test.sh',
            args: ['arg1', 'arg2', 'arg3'],
            workingDirectory: '/workDir',
            runInDocker: false,
            envVars: {"thing": "bob", "which": "that"})).called(1));
  });
}
