import 'package:overscript/repositories/scripts_store_repository.dart';
import 'package:test/test.dart';

void main() {
  group('ScriptsStoreRepository', () {
    late ScriptsStoreRepository repository;

    setUp(() {
      repository = ScriptsStoreRepository();
    });

    test('add', () {
      repository.add(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: {"thing": "bob", "which": "that"});

      expect(repository.scripts.length, 1);

      expect(repository.scripts[0].name, equals("Test Script"));
      expect(repository.scripts[0].command, equals("test.sh"));
      expect(repository.scripts[0].args[0], equals("arg1"));
      expect(repository.scripts[0].args[1], equals("arg2"));
      expect(repository.scripts[0].workingDirectory, equals("/path/to/work"));
      expect(repository.scripts[0].runInDocker, isFalse);
      expect(repository.scripts[0].uuid, isNotEmpty);
      expect(repository.scripts[0].envVars,
          equals({"thing": "bob", "which": "that"}));

      repository.add(
          uuid: "a-uuid-2",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: {"thing": "bob", "which": "that"});
      expect(repository.scripts.length, 1);

      repository.add(
          uuid: "a-uuid-3",
          name: "Test Script 2",
          command: "test2.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/morework",
          runInDocker: true,
          envVars: {"thing": "bob", "which": "that"});
      expect(repository.scripts.length, 2);

      expect(repository.scripts[1].name, equals("Test Script 2"));
      expect(repository.scripts[1].command, equals("test2.sh"));
      expect(repository.scripts[1].args[0], equals("arg1"));
      expect(repository.scripts[1].args[1], equals("arg2"));
      expect(
          repository.scripts[1].workingDirectory, equals("/path/to/morework"));
      expect(repository.scripts[1].runInDocker, isTrue);
      expect(repository.scripts[1].uuid, isNotEmpty);
      expect(repository.scripts[0].envVars,
          equals({"thing": "bob", "which": "that"}));
    });

    test('edit', () {
      repository.add(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: {"thing": "bob", "which": "that"});

      expect(repository.scripts.length, 1);

      var savedUuid = repository.scripts[0].uuid;

      repository.edit(
          uuid: "a-uuid",
          name: "Edited Script",
          command: "editcommand.sh",
          args: ["arg1", "arg2", "arg3"],
          workingDirectory: "/edited",
          runInDocker: false,
          envVars: {"thing": "bob", "which": "that"});

      expect(repository.scripts.length, 1);

      expect(repository.scripts[0].name, equals("Edited Script"));
      expect(repository.scripts[0].command, equals("editcommand.sh"));
      expect(repository.scripts[0].args[0], equals("arg1"));
      expect(repository.scripts[0].args[1], equals("arg2"));
      expect(repository.scripts[0].args[2], equals("arg3"));
      expect(repository.scripts[0].workingDirectory, equals("/edited"));
      expect(repository.scripts[0].runInDocker, isFalse);
      expect(repository.scripts[0].uuid, equals(savedUuid));
      expect(repository.scripts[0].envVars,
          equals({"thing": "bob", "which": "that"}));
    });

    test('delete', () {
      repository.add(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: {"thing": "bob", "which": "that"});

      expect(repository.scripts.length, 1);

      var savedUuid = repository.scripts[0].uuid;

      repository.delete(savedUuid);

      expect(repository.scripts.length, 0);
    });

    test('save and load', () {
      repository.add(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: {"thing": "bob", "which": "that"});

      expect(repository.scripts.length, 1);
      repository.add(
          uuid: "a-uuid-3",
          name: "Test Script 2",
          command: "test2.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/morework",
          runInDocker: true,
          envVars: {"thing": "bob", "which": "that"});

      repository.save('testfile.json');

      ScriptsStoreRepository repository2 = ScriptsStoreRepository();
      repository2.load('testfile.json');

      expect(repository2.scripts.length, 2);

      expect(repository2.scripts[0].name, equals("Test Script"));
      expect(repository2.scripts[0].command, equals("test.sh"));
      expect(repository2.scripts[0].args[0], equals("arg1"));
      expect(repository2.scripts[0].args[1], equals("arg2"));
      expect(repository2.scripts[0].workingDirectory, equals("/path/to/work"));
      expect(repository2.scripts[0].runInDocker, isFalse);
      expect(repository2.scripts[0].uuid, isNotEmpty);

      expect(repository2.scripts[1].name, equals("Test Script 2"));
      expect(repository2.scripts[1].command, equals("test2.sh"));
      expect(repository2.scripts[1].args[0], equals("arg1"));
      expect(repository2.scripts[1].args[1], equals("arg2"));
      expect(
          repository2.scripts[1].workingDirectory, equals("/path/to/morework"));
      expect(repository2.scripts[1].runInDocker, isTrue);
      expect(repository2.scripts[1].uuid, isNotEmpty);
      expect(repository.scripts[0].envVars,
          equals({"thing": "bob", "which": "that"}));
    });
  });
}
