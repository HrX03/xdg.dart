import 'dart:io';

import 'package:path/path.dart';
import 'package:xdg_desktop/xdg_desktop.dart';

void main(List<String> arguments) async {
  final String path = arguments.first;
  final List<FileSystemEntity> entities =
      await Directory(path).list(recursive: true).toList();

  for (final FileSystemEntity entity in entities) {
    if (entity is! File) continue;
    if (extension(entity.path) != ".theme") continue;

    final String content = await entity.readAsString();
    try {
      final IconTheme entry = IconTheme.fromIni(entity.parent.path, content);
      print(entry.name);
      print(entry.comment);
      print(entry.inherits);
      print(entry.directoryNames);
      print(entry.scaledDirectories);
      print(entry.hidden);
      print(entry.example);
    } catch (e) {
      print(e);
      print('e: ${entity.path}');
    }
  }
}
