import 'package:collection/collection.dart';
import 'package:ini/ini.dart';

class IniUtils {
  final String defaultSection;

  const IniUtils(this.defaultSection);

  static RegExp _getListRegex(String separator) =>
      RegExp(r"(?<!\\)\" + separator);
  static RegExp _getLocaleStringRegex(String key) => RegExp(
        key +
            r"\[(?<language>[a-zA-Z]+)(_(?<country>[a-zA-Z]+))?(@(?<modifier>[a-zA-Z]+))?\]",
      );

  static void setIniValue<T>(
    Config ini,
    String section,
    String option,
    T value,
    String? Function(T? argument) converter,
  ) {
    final String? resolvedValue = converter(value);
    if (resolvedValue != null) ini.set(section, option, resolvedValue);
  }

  static String? getValue(
    Config ini,
    String key,
    String group,
    bool optional,
  ) {
    if (!ini.hasOption(group, key) && !optional) {
      throw NoKeyException(key, group);
    }

    return ini.get(group, key);
  }

  String? getString(
    Config ini,
    String key, {
    String? group,
    bool optional = true,
  }) {
    group ??= defaultSection;
    final String? source = getValue(ini, key, group, optional);

    if (source == null) return null;

    if (!RegExp(r'^[\x00-\x7F]+$').hasMatch(source)) {
      throw ValueCastException(
        requestedType: 'string',
        value: source,
        key: key,
        group: group,
      );
    }

    return source;
  }

  LocalizedString? getLocaleString(
    Config ini,
    String key, {
    String? group,
    bool optional = true,
  }) {
    group ??= defaultSection;
    final String? main = getValue(ini, key, group, optional);
    final List<String>? localizedOptions = ini
        .options(group)
        ?.where(
          (e) => e.startsWith(_getLocaleStringRegex(key)),
        )
        .toList();

    final Map<XdgLocale, String> localizedStrings = {};
    if (localizedOptions != null && localizedOptions.isNotEmpty) {
      for (final String localizedOption in localizedOptions) {
        final String? value = getValue(ini, localizedOption, group, optional);

        if (value == null) continue;
        final RegExpMatch? match =
            _getLocaleStringRegex(key).firstMatch(localizedOption);

        if (match == null) continue;

        final String? language = match.namedGroup("language");
        final String? country = match.namedGroup("country");
        final String? modifier = match.namedGroup("modifier");

        if (language == null) continue;

        final XdgLocale locale = XdgLocale(
          language,
          country,
          modifier,
        );

        localizedStrings[locale] = value;
      }
    }

    return main != null
        ? LocalizedString(main, localized: localizedStrings)
        : null;
  }

  List<String>? getList(
    Config ini,
    String key, {
    String? group,
    bool optional = true,
  }) {
    group ??= defaultSection;
    final String? source = getValue(ini, key, group, optional);

    if (source == null) return null;

    final RegExp semicolonRegex = _getListRegex(";");
    final RegExp pipeRegex = _getListRegex("|");
    final RegExp commaRegex = _getListRegex(",");

    final List<String> list;

    if (semicolonRegex.hasMatch(source)) {
      list = source.split(semicolonRegex);
    } else if (pipeRegex.hasMatch(source)) {
      list = source.split(pipeRegex);
    } else if (commaRegex.hasMatch(source)) {
      list = source.split(commaRegex);
    } else {
      list = [source];
    }

    if (list.last.isEmpty) {
      list.removeLast();
    }

    return list;
  }

  bool? getBool(
    Config ini,
    String key, {
    String? group,
    bool optional = true,
  }) {
    group ??= defaultSection;
    final String? source = getValue(ini, key, group, optional);

    if (source == null) return null;

    switch (source) {
      case 'true':
      case 'True':
      case '1':
        return true;
      case 'false':
      case 'False':
      case '0':
        return false;
      default:
        throw ValueCastException(
          requestedType: 'boolean',
          value: source,
          key: key,
          group: group,
          allowedValues: [
            'true',
            'True',
            '1',
            'false',
            'False',
            '0',
          ],
        );
    }
  }

  double? getNumeric(
    Config ini,
    String key, {
    String? group,
    bool optional = true,
  }) {
    group ??= defaultSection;
    final String? source = getValue(ini, key, group, optional);

    if (source == null) return null;

    final double? value = double.tryParse(source);

    if (value == null) {
      throw ValueCastException(
        requestedType: 'numeric',
        value: source,
        key: key,
        group: group,
      );
    }

    return value;
  }

  int? getInteger(
    Config ini,
    String key, {
    String? group,
    bool optional = true,
  }) {
    group ??= defaultSection;
    final String? source = getValue(ini, key, group, optional);

    if (source == null) return null;

    final int? value = int.tryParse(source);

    if (value == null) {
      throw ValueCastException(
        requestedType: 'integer',
        value: source,
        key: key,
        group: group,
      );
    }

    return value;
  }
}

class NoKeyException implements Exception {
  final String key;
  final String group;

  const NoKeyException(this.key, this.group);

  @override
  String toString() {
    return "The key '$key' was not found inside the group '$group'";
  }
}

class ValueCastException implements Exception {
  final String requestedType;
  final String value;
  final String key;
  final String group;
  final List<String>? allowedValues;

  const ValueCastException({
    required this.requestedType,
    required this.value,
    required this.key,
    required this.group,
    this.allowedValues,
  });

  @override
  String toString() {
    String msg =
        "Unable to cast '$value' to '$requestedType' for key '$key' in group '$group'. ";

    if (allowedValues != null && allowedValues!.isNotEmpty) {
      msg += "Only allowed values are ${allowedValues!.join(', ')}";
    }

    return msg;
  }
}

String? stringConverter(String? arg) => arg;

String? booleanConverter(bool? arg) {
  switch (arg) {
    case true:
      return 'True';
    case false:
      return 'False';
    default:
      return null;
  }
}

String? listConverter(List<String>? arg) {
  if (arg == null) return null;

  return "${arg.join(";")};";
}

class LocalizedString {
  final String main;
  final Map<XdgLocale, String> localized;

  const LocalizedString(
    this.main, {
    this.localized = const {},
  });

  @override
  String toString() {
    final Iterable<String> values =
        localized.entries.map((e) => "${e.key} ${e.value}");
    return "$main {${values.join(", ")}}";
  }

  String getForLocale(XdgLocale locale) {
    if (localized.isNotEmpty) {
      XdgLocale? closestLocale;

      closestLocale = localized.keys.firstWhereOrNull(
        (e) =>
            locale.modifier == e.modifier &&
            locale.country == e.country &&
            locale.lang == e.lang,
      );

      if (closestLocale != null) return localized[closestLocale]!;

      closestLocale = localized.keys.firstWhereOrNull(
        (e) => locale.country == e.country && locale.lang == e.lang,
      );

      if (closestLocale != null) return localized[closestLocale]!;

      closestLocale = localized.keys.firstWhereOrNull(
        (e) => locale.modifier == e.modifier && locale.lang == e.lang,
      );

      if (closestLocale != null) return localized[closestLocale]!;

      closestLocale =
          localized.keys.firstWhereOrNull((e) => locale.lang == e.lang);

      if (closestLocale != null) return localized[closestLocale]!;
    }

    return main;
  }
}

class XdgLocale {
  final String lang;
  final String? country;
  final String? modifier;

  const XdgLocale(this.lang, [this.country, this.modifier]);

  @override
  String toString() {
    final String countryStr = country != null ? "_$country" : "";
    final String modifierStr = modifier != null ? "@$modifier" : "";

    return "$lang$countryStr$modifierStr";
  }

  @override
  int get hashCode => Object.hash(lang, country, modifier);

  @override
  bool operator ==(Object? other) {
    if (other is XdgLocale) {
      return lang.toLowerCase() == other.lang.toLowerCase() &&
          country?.toLowerCase() == other.country?.toLowerCase() &&
          modifier?.toLowerCase() == other.modifier?.toLowerCase();
    }

    return false;
  }
}
