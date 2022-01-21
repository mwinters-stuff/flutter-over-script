import 'package:overscript/repositories/repositories.dart';
import 'package:test/test.dart';

void main() {
  group('DataStoreRepository', () {
    late DataStoreRepository repository;

    setUp(() {
      repository = DataStoreRepository();
    });

    test('addScript', () {
      repository.addScript(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);

      expect(repository.scripts.length, 1);

      expect(repository.scripts[0].name, equals("Test Script"));
      expect(repository.scripts[0].command, equals("test.sh"));
      expect(repository.scripts[0].args[0], equals("arg1"));
      expect(repository.scripts[0].args[1], equals("arg2"));
      expect(repository.scripts[0].workingDirectory, equals("/path/to/work"));
      expect(repository.scripts[0].runInDocker, isFalse);
      expect(repository.scripts[0].uuid, isNotEmpty);
      expect(repository.scripts[0].envVars, equals([const StringPair("thing", "bob"), const StringPair("which", "that")]));

      repository.addScript(
          uuid: "a-uuid-2",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);
      expect(repository.scripts.length, 1);

      repository.addScript(
          uuid: "a-uuid-3",
          name: "Test Script 2",
          command: "test2.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/morework",
          runInDocker: true,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);
      expect(repository.scripts.length, 2);

      expect(repository.scripts[1].name, equals("Test Script 2"));
      expect(repository.scripts[1].command, equals("test2.sh"));
      expect(repository.scripts[1].args[0], equals("arg1"));
      expect(repository.scripts[1].args[1], equals("arg2"));
      expect(repository.scripts[1].workingDirectory, equals("/path/to/morework"));
      expect(repository.scripts[1].runInDocker, isTrue);
      expect(repository.scripts[1].uuid, isNotEmpty);
      expect(repository.scripts[0].envVars, equals([const StringPair("thing", "bob"), const StringPair("which", "that")]));
    });

    test('editScript', () {
      repository.addScript(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);

      expect(repository.scripts.length, 1);

      var savedUuid = repository.scripts[0].uuid;

      repository.editScript(
          uuid: "a-uuid",
          name: "Edited Script",
          command: "editcommand.sh",
          args: ["arg1", "arg2", "arg3"],
          workingDirectory: "/edited",
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);

      expect(repository.scripts.length, 1);

      expect(repository.scripts[0].name, equals("Edited Script"));
      expect(repository.scripts[0].command, equals("editcommand.sh"));
      expect(repository.scripts[0].args[0], equals("arg1"));
      expect(repository.scripts[0].args[1], equals("arg2"));
      expect(repository.scripts[0].args[2], equals("arg3"));
      expect(repository.scripts[0].workingDirectory, equals("/edited"));
      expect(repository.scripts[0].runInDocker, isFalse);
      expect(repository.scripts[0].uuid, equals(savedUuid));
      expect(repository.scripts[0].envVars, equals([const StringPair("thing", "bob"), const StringPair("which", "that")]));

      repository.addScript(
          uuid: "a-uuid-3",
          name: "Test Script 2",
          command: "test2.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/morework",
          runInDocker: true,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);
      expect(repository.scripts.length, 2);

      repository.editScript(
          uuid: "a-uuid",
          name: "Test Script 2",
          command: "editcommand.sh",
          args: ["arg1", "arg2", "arg3"],
          workingDirectory: "/edited",
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);

      expect(repository.scripts.length, 2);

      expect(repository.scripts[0].name, equals("Edited Script"));
      expect(repository.scripts[0].command, equals("editcommand.sh"));
      expect(repository.scripts[0].args[0], equals("arg1"));
      expect(repository.scripts[0].args[1], equals("arg2"));
      expect(repository.scripts[0].args[2], equals("arg3"));
      expect(repository.scripts[0].workingDirectory, equals("/edited"));
      expect(repository.scripts[0].runInDocker, isFalse);
      expect(repository.scripts[0].uuid, equals(savedUuid));
      expect(repository.scripts[0].envVars, equals([const StringPair("thing", "bob"), const StringPair("which", "that")]));
    });

    test('deleteScript', () {
      repository.addScript(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);

      expect(repository.scripts.length, 1);

      var savedUuid = repository.scripts[0].uuid;

      repository.deleteScript(savedUuid);

      expect(repository.scripts.length, 0);
    });

    test('addVariable', () {
      repository.addVariable(uuid: "a-uuid-1", name: "var1", branchValues: [const StringPair("b1", "v11"), const StringPair("b2", "v21")]);

      expect(repository.variables.length, 1);
      expect(repository.variables[0].uuid, equals("a-uuid-1"));
      expect(repository.variables[0].name, equals("var1"));
      expect(repository.variables[0].branchValues, equals([const StringPair("b1", "v11"), const StringPair("b2", "v21")]));

      repository.addVariable(uuid: "a-uuid-2", name: "var1", branchValues: [const StringPair("b1", "v11"), const StringPair("b2", "v21")]);

      expect(repository.variables.length, 1);

      repository.addVariable(uuid: "a-uuid-2", name: "var2", branchValues: [const StringPair("b1", "v21"), const StringPair("b2", "v22")]);
      repository.addVariable(uuid: "a-uuid-3", name: "var3", branchValues: [const StringPair("b1", "v31"), const StringPair("b2", "v23")]);

      expect(repository.variables.length, 3);

      expect(repository.variables[1].uuid, equals("a-uuid-2"));
      expect(repository.variables[1].name, equals("var2"));
      expect(repository.variables[1].branchValues, equals([const StringPair("b1", "v21"), const StringPair("b2", "v22")]));

      expect(repository.variables[2].uuid, equals("a-uuid-3"));
      expect(repository.variables[2].name, equals("var3"));
      expect(repository.variables[2].branchValues, equals([const StringPair("b1", "v31"), const StringPair("b2", "v23")]));
    });

    test('editVariable', () {
      repository.addVariable(uuid: "a-uuid-1", name: "var1", branchValues: [const StringPair("b1", "v11"), const StringPair("b2", "v21")]);

      expect(repository.variables.length, 1);

      repository.editVariable(uuid: "a-uuid-1", name: "var1_edit", branchValues: [const StringPair("b1", "v111"), const StringPair("b2", "v211")]);

      expect(repository.variables.length, 1);

      expect(repository.variables[0].uuid, equals("a-uuid-1"));
      expect(repository.variables[0].name, equals("var1_edit"));
      expect(repository.variables[0].branchValues, equals([const StringPair("b1", "v111"), const StringPair("b2", "v211")]));

      repository.addVariable(uuid: "a-uuid-2", name: "var2", branchValues: [const StringPair("b1", "v21"), const StringPair("b2", "v22")]);
      expect(repository.variables.length, 2);

      repository.editVariable(uuid: "a-uuid-1", name: "var2", branchValues: [const StringPair("b1", "v111"), const StringPair("b2", "v211")]);

      expect(repository.variables.length, 2);

      expect(repository.variables[0].uuid, equals("a-uuid-1"));
      expect(repository.variables[0].name, equals("var1_edit"));
      expect(repository.variables[0].branchValues, equals([const StringPair("b1", "v111"), const StringPair("b2", "v211")]));
    });

    test('deleteVariable', () {
      repository.addVariable(uuid: "a-uuid-1", name: "var1", branchValues: [const StringPair("b1", "v11"), const StringPair("b2", "v21")]);

      expect(repository.variables.length, 1);

      var savedUuid = repository.variables[0].uuid;

      repository.deleteVariable(savedUuid);

      expect(repository.variables.length, 0);
    });

    test('save and load', () {
      repository.addScript(
          uuid: "a-uuid",
          name: "Test Script",
          command: "test.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/work",
          runInDocker: false,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);

      expect(repository.scripts.length, 1);
      repository.addScript(
          uuid: "a-uuid-3",
          name: "Test Script 2",
          command: "test2.sh",
          args: ["arg1", "arg2"],
          workingDirectory: "/path/to/morework",
          runInDocker: true,
          envVars: [const StringPair("thing", "bob"), const StringPair("which", "that")]);
      expect(repository.scripts.length, 2);

      repository.addVariable(uuid: "a-uuid-1", name: "var1", branchValues: [const StringPair("b1", "v11"), const StringPair("b2", "v21")]);
      repository.addVariable(uuid: "a-uuid-2", name: "var2", branchValues: [const StringPair("b1", "v21"), const StringPair("b2", "v22")]);
      repository.addVariable(uuid: "a-uuid-3", name: "var3", branchValues: [const StringPair("b1", "v31"), const StringPair("b2", "v23")]);
      expect(repository.variables.length, 3);

      repository.addBranch(uuid: 'uuid-1', name: 'master', directory: '/src/master');
      repository.addBranch(uuid: 'uuid-2', name: 'branch1', directory: '/src/branch1');

      expect(repository.branches.length, 2);
      repository.save('testfile.json');

      DataStoreRepository repository2 = DataStoreRepository();
      repository2.load('testfile.json');

      expect(repository2.scripts.length, 2);

      expect(repository2.scripts[0].name, equals("Test Script"));
      expect(repository2.scripts[0].command, equals("test.sh"));
      expect(repository2.scripts[0].args[0], equals("arg1"));
      expect(repository2.scripts[0].args[1], equals("arg2"));
      expect(repository2.scripts[0].workingDirectory, equals("/path/to/work"));
      expect(repository2.scripts[0].runInDocker, isFalse);
      expect(repository2.scripts[0].uuid, equals("a-uuid"));
      expect(repository2.scripts[0].envVars, equals([const StringPair("thing", "bob"), const StringPair("which", "that")]));

      expect(repository2.scripts[1].name, equals("Test Script 2"));
      expect(repository2.scripts[1].command, equals("test2.sh"));
      expect(repository2.scripts[1].args[0], equals("arg1"));
      expect(repository2.scripts[1].args[1], equals("arg2"));
      expect(repository2.scripts[1].workingDirectory, equals("/path/to/morework"));
      expect(repository2.scripts[1].runInDocker, isTrue);
      expect(repository2.scripts[1].uuid, equals("a-uuid-3"));
      expect(repository2.scripts[1].envVars, equals([const StringPair("thing", "bob"), const StringPair("which", "that")]));

      expect(repository2.variables.length, 3);

      expect(repository2.variables[0].uuid, equals("a-uuid-1"));
      expect(repository2.variables[0].name, equals("var1"));
      expect(repository2.variables[0].branchValues, equals([const StringPair("b1", "v11"), const StringPair("b2", "v21")]));

      expect(repository2.variables[1].uuid, equals("a-uuid-2"));
      expect(repository2.variables[1].name, equals("var2"));
      expect(repository2.variables[1].branchValues, equals([const StringPair("b1", "v21"), const StringPair("b2", "v22")]));

      expect(repository2.variables[2].uuid, equals("a-uuid-3"));
      expect(repository2.variables[2].name, equals("var3"));
      expect(repository2.variables[2].branchValues, equals([const StringPair("b1", "v31"), const StringPair("b2", "v23")]));

      expect(repository2.branches.length, 2);

      expect(repository2.branches[0].uuid, equals("uuid-1"));
      expect(repository2.branches[0].name, equals("master"));
      expect(repository2.branches[0].directory, equals("/src/master"));

      expect(repository2.branches[1].uuid, equals("uuid-2"));
      expect(repository2.branches[1].name, equals("branch1"));
      expect(repository2.branches[1].directory, equals("/src/branch1"));
    });
  });
}
