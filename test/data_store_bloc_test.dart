import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:overscript/bloc/bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'data_store_bloc_test.mocks.dart';

@GenerateMocks([DataStoreRepository])
void main() {
  group('DataStoreBloc', () {
    late DataStoreBloc dataStoreBloc;

    var storedScript = const StoredScript(
        uuid: 'uuid',
        name: 'Test Script',
        command: 'test.sh',
        args: ['arg1', 'arg2', 'arg3'],
        workingDirectory: '/workDir',
        runInDocker: false,
        envVars: [StringPair("thing", "bob"), StringPair("which", "that")]);

    var storedVariable = const StoredVariable(uuid: "a-uuid-1", name: "var1", branchValues: [StringPair("b1", "v11"), StringPair("b2", "v21")]);

    MockDataStoreRepository _mockRepository = MockDataStoreRepository();

    setUp(() {
      dataStoreBloc = DataStoreBloc(repository: _mockRepository);
    });

    blocTest<DataStoreBloc, DataStoreState>(
      'Loads the script store',
      build: () {
        when(_mockRepository.scripts).thenReturn(<StoredScript>[]);
        when(_mockRepository.variables).thenReturn(<StoredVariable>[]);
        return dataStoreBloc;
      },
      act: (bloc) => bloc.add(const DataStoreLoad('test.json')),
      expect: () => [DataStoreLoading(), const DataStoreUpdated(<StoredScript>[], <StoredVariable>[])],
      verify: (bloc) => verify(_mockRepository.load('test.json')).called(1),
    );

    blocTest<DataStoreBloc, DataStoreState>(
      'Saves the script store',
      build: () {
        when(_mockRepository.scripts).thenReturn(<StoredScript>[]);
        when(_mockRepository.variables).thenReturn(<StoredVariable>[]);
        return dataStoreBloc;
      },
      act: (bloc) => bloc.add(const DataStoreSave('test.json')),
      expect: () => [
        const DataStoreSaving(<StoredScript>[], <StoredVariable>[]),
        const DataStoreSaved(<StoredScript>[], <StoredVariable>[]),
      ],
      verify: (bloc) => verify(_mockRepository.save('test.json')).called(1),
    );

    blocTest<DataStoreBloc, DataStoreState>(
      'Adds script to store.',
      build: () {
        when(_mockRepository.scripts).thenReturn(<StoredScript>[storedScript]);
        when(_mockRepository.variables).thenReturn(<StoredVariable>[storedVariable]);
        return dataStoreBloc;
      },
      act: (bloc) => bloc.add(const ScriptStoreAddEvent(
          name: 'Test Script',
          command: 'test.sh',
          args: ['arg1', 'arg2', 'arg3'],
          workingDirectory: '/workDir',
          runInDocker: false,
          envVars: [StringPair("thing", "bob"), StringPair("which", "that")])),
      expect: () => [
        DataStoreUpdating(),
        DataStoreUpdated([storedScript], [storedVariable]),
      ],
      verify: (bloc) => verify(_mockRepository.addScript(
          uuid: argThat(isNotEmpty, named: 'uuid'),
          name: 'Test Script',
          command: 'test.sh',
          args: ['arg1', 'arg2', 'arg3'],
          workingDirectory: '/workDir',
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")])).called(1),
    );

    blocTest<DataStoreBloc, DataStoreState>('Edits script in store.',
        build: () {
          when(_mockRepository.scripts).thenReturn(<StoredScript>[storedScript]);
          when(_mockRepository.variables).thenReturn(<StoredVariable>[storedVariable]);
          return dataStoreBloc;
        },
        act: (bloc) => bloc.add(const ScriptStoreEditEvent(
            uuid: 'uuid',
            name: 'Test Script',
            command: 'test.sh',
            args: ['arg1', 'arg2', 'arg3'],
            workingDirectory: '/workDir',
            runInDocker: false,
            envVars: [StringPair("thing", "bob"), StringPair("which", "that")])),
        expect: () => [
              DataStoreUpdating(),
              DataStoreUpdated([storedScript], [storedVariable]),
            ],
        verify: (bloc) => verify(_mockRepository.editScript(
            uuid: 'uuid',
            name: 'Test Script',
            command: 'test.sh',
            args: ['arg1', 'arg2', 'arg3'],
            workingDirectory: '/workDir',
            runInDocker: false,
            envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")])).called(1));

    blocTest<DataStoreBloc, DataStoreState>('Delete script in store.',
        build: () {
          when(_mockRepository.scripts).thenReturn(<StoredScript>[storedScript]);
          when(_mockRepository.variables).thenReturn(<StoredVariable>[storedVariable]);
          return dataStoreBloc;
        },
        act: (bloc) => bloc.add(const ScriptStoreDeleteEvent(uuid: 'uuid')),
        expect: () => [
              DataStoreUpdating(),
              DataStoreUpdated([storedScript], [storedVariable]),
            ],
        verify: (bloc) => verify(_mockRepository.deleteScript('uuid')).called(1));

    blocTest<DataStoreBloc, DataStoreState>('Adds variable to store.',
        build: () {
          when(_mockRepository.scripts).thenReturn(<StoredScript>[storedScript]);
          when(_mockRepository.variables).thenReturn(<StoredVariable>[storedVariable]);
          return dataStoreBloc;
        },
        act: (bloc) => bloc.add(const VariableStoreAddEvent(name: 'Test Script', branchValues: [StringPair("b1", "v11"), StringPair("b2", "v21")])),
        expect: () => [
              DataStoreUpdating(),
              DataStoreUpdated([storedScript], [storedVariable]),
            ],
        verify: (bloc) =>
            verify(_mockRepository.addVariable(uuid: argThat(isNotEmpty, named: 'uuid'), name: 'Test Script', branchValues: [const StringPair("b1", "v11"), const StringPair("b2", "v21")])).called(1));

    blocTest<DataStoreBloc, DataStoreState>('Edits variable in store.',
        build: () {
          when(_mockRepository.scripts).thenReturn(<StoredScript>[storedScript]);
          when(_mockRepository.variables).thenReturn(<StoredVariable>[storedVariable]);
          return dataStoreBloc;
        },
        act: (bloc) => bloc.add(const VariableStoreEditEvent(uuid: 'a-uuid-1', name: 'Test Script', branchValues: [StringPair("b1", "v11"), StringPair("b2", "v21")])),
        expect: () => [
              DataStoreUpdating(),
              DataStoreUpdated([storedScript], [storedVariable]),
            ],
        verify: (bloc) => verify(_mockRepository.editVariable(uuid: 'a-uuid-1', name: 'Test Script', branchValues: [const StringPair("b1", "v11"), const StringPair("b2", "v21")])).called(1));

    blocTest<DataStoreBloc, DataStoreState>('Delete variable in store.',
        build: () {
          when(_mockRepository.scripts).thenReturn(<StoredScript>[storedScript]);
          when(_mockRepository.variables).thenReturn(<StoredVariable>[storedVariable]);
          return dataStoreBloc;
        },
        act: (bloc) => bloc.add(const VariableStoreDeleteEvent(uuid: 'a-uuid-1')),
        expect: () => [
              DataStoreUpdating(),
              DataStoreUpdated([storedScript], [storedVariable]),
            ],
        verify: (bloc) => verify(_mockRepository.deleteVariable('a-uuid-1')).called(1));
  });
}
