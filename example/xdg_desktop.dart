import 'dart:io';

import 'package:path/path.dart';
import 'package:xdg_desktop/xdg_desktop.dart';

void main(List<String> arguments) async {
  final String path = arguments.first;
  final List<FileSystemEntity> entities =
      await Directory(path).list(recursive: true).toList();

  for (final FileSystemEntity entity in entities) {
    if (entity is! File) continue;
    if (extension(entity.path) != ".desktop") continue;

    final String content = await entity.readAsString();
    try {
      final DesktopEntry entry = DesktopEntry.fromIni(content);
      if (entry.noDisplay != true) print(entry.name);
    } catch (e) {
      print(e);
      print('e: ${entity.path}');
    }
  }
}
