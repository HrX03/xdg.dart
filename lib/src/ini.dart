import 'package:ini/ini.dart';

class IniUtils {
  final String defaultSection;

  const IniUtils(this.defaultSection);

  static RegExp _getListRegex(String separator) =>
      RegExp(r"(?<!\\)\" + separator);

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

  String? getLocaleString(
    Config ini,
    String key, {
    String? group,
    bool optional = true,
  }) {
    group ??= defaultSection;
    return getValue(ini, key, group, optional);
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
