import 'dart:io';

bool isDirectory(String path) {
  return FileStat.statSync(path).type == FileSystemEntityType.directory;
}

String getHostIPAddress() {
  return Process.runSync(
          'bash', ['-c', 'ip -o route get to 8.8.8.8 | cut -d \' \' -f 7'])
      .stdout
      .toString()
      .trim();
}
