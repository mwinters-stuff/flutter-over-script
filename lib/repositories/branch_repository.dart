import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class BranchRepository {
  final List<Branch> branches;
  BranchRepository() : branches = [];

  Future<List<Branch>> getBranches(BuildContext context) =>
      listBranches(context);

  Future<List<Branch>> listBranches(BuildContext context) async {
    if (branches.isNotEmpty) {
      return branches;
    }

    final configurationRepository =
        RepositoryProvider.of<ConfigurationRepository>(context);
    final rootPath = configurationRepository.sourcePath.getValue();

    final paths = Directory(p.join(rootPath)).listSync();
    for (var element in paths) {
      final line = p.basename(element.path);
      if (line.startsWith('ctct_products_')) {
        final line = element.path;
        dog.d('Found Branch Directory $line');
        final gitbranch = Process.runSync(
            'git', ['-C', element.path, 'rev-parse', '--abbrev-ref', 'HEAD']);
        dog.d('Git Branch Directory ${gitbranch.stdout}');
        branches.add(Branch(line, line.substring(line.lastIndexOf('_') + 1),
            gitbranch.stdout.toString().trim()));
      }
    }
    return branches;
  }

  Branch? getBranchFromName({required String? name}) {
    for (var element in branches) {
      if (element.name == name) {
        return element;
      }
    }
    return null;
  }
}
