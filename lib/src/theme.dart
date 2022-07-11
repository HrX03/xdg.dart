import 'package:collection/collection.dart';
import 'package:ini/ini.dart';
import 'package:xdg_desktop/src/ini.dart';

class IconTheme {
  static const String defaultSection = "Icon Theme";
  static const IniUtils _iniUtils = IniUtils(defaultSection);

  static const List<String> keys = [
    nameKey,
    commentKey,
    inheritsKey,
    directoriesKey,
    scaledDirectoriesKey,
    hiddenKey,
    exampleKey,
  ];

  static const String nameKey = 'Name';
  static const String commentKey = 'Comment';
  static const String inheritsKey = 'Inherits';
  static const String directoriesKey = 'Directories';
  static const String scaledDirectoriesKey = 'ScaledDirectories';
  static const String hiddenKey = 'Hidden';
  static const String exampleKey = 'Example';

  final String path;
  final LocalizedString name;
  final LocalizedString comment;
  final List<String>? inherits;
  final List<String> directoryNames;
  final List<String>? scaledDirectories;
  final bool? hidden;
  final String? example;
  final List<IconThemeDirectory> directories;
  final Map<String, String> extra;

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
    this.extra = const {},
  });

  factory IconTheme.fromIni(String path, String content) {
    final Config ini = Config.fromString(content);

    assert(ini.hasSection(IconTheme.defaultSection));
    assert(ini.hasOption(defaultSection, IconTheme.nameKey));
    assert(ini.hasOption(defaultSection, IconTheme.commentKey));

    final LocalizedString name = _iniUtils.getLocaleString(
      ini,
      IconTheme.nameKey,
      optional: false,
    )!;

    final LocalizedString comment = _iniUtils.getLocaleString(
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
        IconThemeDirectory.sizeKey,
        group: directory,
        optional: false,
      )!;

      final int? scale = _iniUtils.getInteger(
        ini,
        IconThemeDirectory.scaleKey,
        group: directory,
      );

      final String? context = _iniUtils.getString(
        ini,
        IconThemeDirectory.contextKey,
        group: directory,
      );

      final String? type = _iniUtils.getString(
        ini,
        IconThemeDirectory.typeKey,
        group: directory,
      );

      final int? maxSize = _iniUtils.getInteger(
        ini,
        IconThemeDirectory.maxSizeKey,
        group: directory,
      );

      final int? minSize = _iniUtils.getInteger(
        ini,
        IconThemeDirectory.minSizeKey,
        group: directory,
      );

      final int? threshold = _iniUtils.getInteger(
        ini,
        IconThemeDirectory.thresholdKey,
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

    final List<String> extraOptions = ini.options(defaultSection)!.toList();
    extraOptions.removeWhere((e) => keys.contains(e));

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
      extra: Map.fromIterables(
        extraOptions,
        extraOptions.map((e) => ini.get(defaultSection, e)!),
      ),
    );
  }

  IconTheme copyWith({
    String? path,
    LocalizedString? name,
    LocalizedString? comment,
    List<String>? inherits,
    List<String>? directoryNames,
    List<String>? scaledDirectories,
    bool? hidden,
    String? example,
    List<IconThemeDirectory>? directories,
    Map<String, String>? extra,
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
      extra: extra ?? this.extra,
    );
  }

  @override
  int get hashCode => Object.hash(
        path,
        name,
        comment,
        inherits,
        directoryNames,
        scaledDirectories,
        hidden,
        example,
        directories,
        extra,
      );

  @override
  bool operator ==(Object other) {
    if (other is IconTheme) {
      final ListEquality eq = ListEquality();

      return path == other.path &&
          name == other.name &&
          comment == other.comment &&
          eq.equals(inherits, other.inherits) &&
          eq.equals(directoryNames, other.directoryNames) &&
          eq.equals(scaledDirectories, other.scaledDirectories) &&
          hidden == other.hidden &&
          example == other.example &&
          eq.equals(directories, other.directories) &&
          extra == other.extra;
    }

    return false;
  }
}

class IconThemeDirectory {
  static const String sizeKey = 'Size';
  static const String scaleKey = 'Scale';
  static const String contextKey = 'Context';
  static const String typeKey = 'Type';
  static const String minSizeKey = 'MinSize';
  static const String maxSizeKey = 'MaxSize';
  static const String thresholdKey = 'Threshold';

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
