import 'package:ini/ini.dart';
import 'package:xdg_desktop/src/ini.dart';

class IconTheme {
  static const String defaultSection = "Icon Theme";
  static const IniUtils _iniUtils = IniUtils(defaultSection);

  static const String nameKey = 'Name';
  static const String commentKey = 'Comment';
  static const String inheritsKey = 'Inherits';
  static const String directoriesKey = 'Directories';
  static const String scaledDirectoriesKey = 'ScaledDirectories';
  static const String hiddenKey = 'Hidden';
  static const String exampleKey = 'Example';

  static const String sizeDirKey = 'Size';
  static const String scaleDirKey = 'Scale';
  static const String contextDirKey = 'Context';
  static const String typeDirKey = 'Type';
  static const String minSizeDirKey = 'MinSize';
  static const String maxSizeDirKey = 'MaxSize';
  static const String thresholdDirKey = 'Threshold';

  final String path;
  final String name;
  final String comment;
  final List<String>? inherits;
  final List<String> directoryNames;
  final List<String>? scaledDirectories;
  final bool? hidden;
  final String? example;
  final List<IconThemeDirectory> directories;

  const IconTheme({
    required this.path,
    required this.name,
    required this.comment,
    this.inherits,
    required this.directoryNames,
    this.scaledDirectories,
    this.hidden,
    this.example,
    required this.directories,
  });

  factory IconTheme.fromIni(String path, String content) {
    final Config ini = Config.fromString(content);

    assert(ini.hasSection(IconTheme.defaultSection));
    assert(ini.hasOption(defaultSection, IconTheme.nameKey));
    assert(ini.hasOption(defaultSection, IconTheme.commentKey));

    final String name = _iniUtils.getLocaleString(
      ini,
      IconTheme.nameKey,
      optional: false,
    )!;

    final String comment = _iniUtils.getLocaleString(
      ini,
      IconTheme.commentKey,
      optional: false,
    )!;

    final List<String>? inherits = _iniUtils.getList(
      ini,
      IconTheme.inheritsKey,
    );

    final List<String> directoryNames = _iniUtils.getList(
      ini,
      IconTheme.directoriesKey,
      optional: false,
    )!;

    final List<String>? scaledDirectories = _iniUtils.getList(
      ini,
      IconTheme.scaledDirectoriesKey,
    );

    final bool? hidden = _iniUtils.getBool(
      ini,
      IconTheme.hiddenKey,
    );

    final String? example = _iniUtils.getString(
      ini,
      IconTheme.exampleKey,
    );

    final List<IconThemeDirectory> directories = [];
    for (final String directory in directoryNames) {
      if (!ini.hasSection(directory)) {
        throw MissingDirectorySectionException(directory);
      }

      final int size = _iniUtils.getInteger(
        ini,
        IconTheme.sizeDirKey,
        group: directory,
        optional: false,
      )!;

      final int? scale = _iniUtils.getInteger(
        ini,
        IconTheme.scaleDirKey,
        group: directory,
      );

      final String? context = _iniUtils.getString(
        ini,
        IconTheme.contextDirKey,
        group: directory,
      );

      final String? type = _iniUtils.getString(
        ini,
        IconTheme.typeDirKey,
        group: directory,
      );

      final int? maxSize = _iniUtils.getInteger(
        ini,
        IconTheme.maxSizeDirKey,
        group: directory,
      );

      final int? minSize = _iniUtils.getInteger(
        ini,
        IconTheme.minSizeDirKey,
        group: directory,
      );

      final int? threshold = _iniUtils.getInteger(
        ini,
        IconTheme.thresholdDirKey,
        group: directory,
      );

      directories.add(
        IconThemeDirectory(
          name: directory,
          size: size,
          scale: scale,
          context: context,
          type: IconThemeDirectoryType.getFromName(type) ??
              IconThemeDirectoryType.threshold,
          minSize: minSize,
          maxSize: maxSize,
          threshold: threshold,
        ),
      );
    }

    return IconTheme(
      path: path,
      name: name,
      comment: comment,
      inherits: inherits,
      directoryNames: directoryNames,
      scaledDirectories: scaledDirectories,
      hidden: hidden,
      example: example,
      directories: List.unmodifiable(directories),
    );
  }

  IconTheme copyWith({
    String? path,
    String? name,
    String? comment,
    List<String>? inherits,
    List<String>? directoryNames,
    List<String>? scaledDirectories,
    bool? hidden,
    String? example,
    List<IconThemeDirectory>? directories,
  }) {
    return IconTheme(
      path: path ?? this.path,
      name: name ?? this.name,
      comment: comment ?? this.comment,
      inherits: inherits ?? this.inherits,
      directoryNames: directoryNames ?? this.directoryNames,
      scaledDirectories: scaledDirectories ?? this.scaledDirectories,
      hidden: hidden ?? this.hidden,
      example: example ?? this.example,
      directories: directories ?? this.directories,
    );
  }
}

class IconThemeDirectory {
  final String name;
  final int size;
  final int? scale;
  final String? context;
  final IconThemeDirectoryType? type;
  final int? maxSize;
  final int? minSize;
  final int? threshold;

  const IconThemeDirectory({
    required this.name,
    required this.size,
    this.scale,
    this.context,
    this.type,
    this.maxSize,
    this.minSize,
    this.threshold,
  });

  @override
  int get hashCode => Object.hash(
        name,
        size,
        scale,
        context,
        type,
        maxSize,
        minSize,
        threshold,
      );

  @override
  bool operator ==(Object other) {
    if (other is IconThemeDirectory) {
      return name == other.name &&
          size == other.size &&
          scale == other.scale &&
          context == other.context &&
          type == other.type &&
          maxSize == other.maxSize &&
          minSize == other.minSize &&
          threshold == other.threshold;
    }

    return false;
  }
}

enum IconThemeDirectoryType {
  fixed('Fixed'),
  scalable('Scalable'),
  threshold('Threshold');

  final String type;

  const IconThemeDirectoryType(this.type);

  static IconThemeDirectoryType? getFromName(String? name) {
    if (name == null) return null;

    if (!IconThemeDirectoryType.values.map((e) => e.type).contains(name)) {
      return null;
    }

    return IconThemeDirectoryType.values.firstWhere((e) => e.type == name);
  }
}

class MissingDirectorySectionException implements Exception {
  final String directory;

  const MissingDirectorySectionException(this.directory);

  @override
  String toString() {
    return "The directory '$directory', defined in the Directories key inside the theme file, had no corresponding section";
  }
}
