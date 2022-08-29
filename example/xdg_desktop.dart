import 'dart:io';

import 'package:path/path.dart';
import 'package:xdg_desktop/xdg_desktop.dart';

void main(List<String> arguments) async {
  final String path = arguments.first;
  final FileSystemEntityType type = FileSystemEntity.typeSync(path);

  switch (type) {
    case FileSystemEntityType.directory:
      final List<FileSystemEntity> entities =
          await Directory(path).list(recursive: true).toList();

      entities.forEach(_parseFile);
      break;
    case FileSystemEntityType.file:
      _parseFile(File(path));
      break;
    default:
      print("Entity not supported");
      break;
  }
}

Future<void> _parseFile(FileSystemEntity entity) async {
  if (entity is! File) return;
  if (extension(entity.path) != ".desktop") return;

  final String content = await entity.readAsString();
  try {
    final DesktopEntry entry = DesktopEntry.fromIni(entity.path, content);
    if (entry.noDisplay != true) print(entry.name);
  } catch (e) {
    print(e);
    print('e: ${entity.path}');
  }
}
