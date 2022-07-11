import 'package:ini/ini.dart';
import 'package:xdg_desktop/src/ini.dart';

class DesktopEntry {
  static const String defaultSection = "Desktop Entry";
  static const IniUtils _iniUtils = IniUtils(defaultSection);

  static const List<String> keys = [
    typeKey,
    versionKey,
    nameKey,
    genericNameKey,
    noDisplayKey,
    commentKey,
    iconKey,
    hiddenKey,
    onlyShowInKey,
    notShowInKey,
    dbusActivatableKey,
    tryExecKey,
    execKey,
    pathKey,
    terminalKey,
    actionsKey,
    mimeTypeKey,
    categoriesKey,
    implementsKey,
    keywordsKey,
    startupNotifyKey,
    startupWmClassKey,
    urlKey,
    prefersNonDefaultGpuKey,
    singleMainWindowKey,
  ];

  static const String typeKey = 'Type';
  static const String versionKey = 'Version';
  static const String nameKey = 'Name';
  static const String genericNameKey = 'GenericName';
  static const String noDisplayKey = 'NoDisplay';
  static const String commentKey = 'Comment';
  static const String iconKey = 'Icon';
  static const String hiddenKey = 'Hidden';
  static const String onlyShowInKey = 'OnlyShowIn';
  static const String notShowInKey = 'NotShowIn';
  static const String dbusActivatableKey = 'DBusActivatable';
  static const String tryExecKey = 'TryExe';
  static const String execKey = 'Exec';
  static const String pathKey = 'Path';
  static const String terminalKey = 'Terminal';
  static const String actionsKey = 'Actions';
  static const String mimeTypeKey = 'MimeType';
  static const String categoriesKey = 'Categories';
  static const String implementsKey = 'Implements';
  static const String keywordsKey = 'Keywords';
  static const String startupNotifyKey = 'StartupNotify';
  static const String startupWmClassKey = 'StartupWMClass';
  static const String urlKey = 'URL';
  static const String prefersNonDefaultGpuKey = 'PrefersNonDefaultGPU';
  static const String singleMainWindowKey = 'SingleMainWindow';

  final DesktopEntryType type;
  final String? version;
  final LocalizedString name;
  final LocalizedString? genericName;
  final bool? noDisplay;
  final LocalizedString? comment;
  final LocalizedString? icon;
  final bool? hidden;
  final List<String>? onlyShowIn;
  final List<String>? notShowIn;
  final bool? dbusActivatable;
  final String? tryExec;
  final String? exec;
  final String? path;
  final bool? terminal;
  final List<String>? actions;
  final List<String>? mimeType;
  final List<String>? categories;
  final List<String>? implements;
  final List<String>? keywords;
  final bool? startupNotify;
  final String? startupWmClass;
  final String? url;
  final bool? prefersNonDefaultGpu;
  final bool? singleMainWindow;
  final Map<String, String> extra;

  final List<DesktopEntryAction>? actionSections;

  const DesktopEntry({
    required this.type,
    this.version,
    required this.name,
    this.genericName,
    this.noDisplay,
    this.comment,
    this.icon,
    this.hidden,
    this.onlyShowIn,
    this.notShowIn,
    this.dbusActivatable,
    this.tryExec,
    this.exec,
    this.path,
    this.terminal,
    this.actions,
    this.mimeType,
    this.categories,
    this.implements,
    this.keywords,
    this.startupNotify,
    this.startupWmClass,
    this.url,
    this.prefersNonDefaultGpu,
    this.singleMainWindow,
    this.actionSections,
    this.extra = const {},
  });

  factory DesktopEntry.fromIni(String content) {
    final Config ini = Config.fromString(content);

    assert(ini.hasSection(DesktopEntry.defaultSection));
    assert(ini.hasOption(defaultSection, DesktopEntry.typeKey));
    assert(ini.hasOption(defaultSection, DesktopEntry.nameKey));

    final DesktopEntryType type = DesktopEntry.getEntryType(
      ini,
      DesktopEntry.typeKey,
      optional: false,
    )!;

    final String? version = _iniUtils.getString(
      ini,
      DesktopEntry.versionKey,
    );

    final LocalizedString name = _iniUtils.getLocaleString(
      ini,
      DesktopEntry.nameKey,
      optional: false,
    )!;

    final LocalizedString? genericName = _iniUtils.getLocaleString(
      ini,
      DesktopEntry.genericNameKey,
    );

    final bool? noDisplay = _iniUtils.getBool(
      ini,
      DesktopEntry.noDisplayKey,
    );

    final LocalizedString? comment = _iniUtils.getLocaleString(
      ini,
      DesktopEntry.commentKey,
    );

    final LocalizedString? icon = _iniUtils.getLocaleString(
      ini,
      DesktopEntry.iconKey,
    );

    final bool? hidden = _iniUtils.getBool(
      ini,
      DesktopEntry.hiddenKey,
    );

    final List<String>? onlyShowIn = _iniUtils.getList(
      ini,
      DesktopEntry.onlyShowInKey,
    );

    final List<String>? notShowIn = _iniUtils.getList(
      ini,
      DesktopEntry.notShowInKey,
    );

    final bool? dbusActivatable = _iniUtils.getBool(
      ini,
      DesktopEntry.dbusActivatableKey,
    );

    final String? tryExec = _iniUtils.getString(
      ini,
      DesktopEntry.tryExecKey,
    );

    final String? exec = _iniUtils.getString(
      ini,
      DesktopEntry.execKey,
    );

    final String? path = _iniUtils.getString(
      ini,
      DesktopEntry.pathKey,
    );

    final bool? terminal = _iniUtils.getBool(
      ini,
      DesktopEntry.terminalKey,
    );

    final List<String>? actions = _iniUtils.getList(
      ini,
      DesktopEntry.actionsKey,
    );

    final List<String>? mimeType = _iniUtils.getList(
      ini,
      DesktopEntry.mimeTypeKey,
    );

    final List<String>? categories = _iniUtils.getList(
      ini,
      DesktopEntry.categoriesKey,
    );

    final List<String>? implements = _iniUtils.getList(
      ini,
      DesktopEntry.implementsKey,
    );

    final List<String>? keywords = _iniUtils.getList(
      ini,
      DesktopEntry.keywordsKey,
    );

    final bool? startupNotify = _iniUtils.getBool(
      ini,
      DesktopEntry.startupNotifyKey,
    );

    final String? startupWmClass = _iniUtils.getString(
      ini,
      DesktopEntry.startupWmClassKey,
    );

    final String? url = _iniUtils.getString(
      ini,
      DesktopEntry.urlKey,
    );

    final bool? prefersNonDefaultGpu = _iniUtils.getBool(
      ini,
      DesktopEntry.prefersNonDefaultGpuKey,
    );

    final bool? singleMainWindow = _iniUtils.getBool(
      ini,
      DesktopEntry.singleMainWindowKey,
    );

    List<DesktopEntryAction>? actionSections;

    for (final String section in ini.sections()) {
      if (section == DesktopEntry.defaultSection) continue;

      if (!section.startsWith('Desktop Action ')) continue;

      actionSections ??= [];

      assert(ini.hasOption(section, DesktopEntry.nameKey));

      final String id = section.replaceFirst('Desktop Action ', '');

      final LocalizedString actionName = _iniUtils.getLocaleString(
        ini,
        DesktopEntry.nameKey,
        group: section,
        optional: false,
      )!;

      final LocalizedString? actionIcon = _iniUtils.getLocaleString(
        ini,
        DesktopEntry.iconKey,
        group: section,
      );

      final String? actionExec = _iniUtils.getString(
        ini,
        DesktopEntry.execKey,
        group: section,
      );

      actionSections.add(DesktopEntryAction(
        id: id,
        name: actionName,
        icon: actionIcon,
        exec: actionExec,
      ));
    }

    final List<String> extraOptions = ini.options(defaultSection)!.toList();
    extraOptions.removeWhere((e) => keys.contains(e));

    return DesktopEntry(
      type: type,
      version: version,
      name: name,
      genericName: genericName,
      noDisplay: noDisplay,
      comment: comment,
      icon: icon,
      hidden: hidden,
      onlyShowIn: onlyShowIn,
      notShowIn: notShowIn,
      dbusActivatable: dbusActivatable,
      tryExec: tryExec,
      exec: exec,
      path: path,
      terminal: terminal,
      actions: actions,
      mimeType: mimeType,
      categories: categories,
      implements: implements,
      keywords: keywords,
      startupNotify: startupNotify,
      startupWmClass: startupWmClass,
      url: url,
      prefersNonDefaultGpu: prefersNonDefaultGpu,
      singleMainWindow: singleMainWindow,
      actionSections: actionSections,
      extra: Map.fromIterables(
        extraOptions,
        extraOptions.map((e) => ini.get(defaultSection, e)!),
      ),
    );
  }

  Config toIni() {
    final Config ini = Config();

    ini.addSection(defaultSection);

    IniUtils.setIniValue<DesktopEntryType>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.typeKey,
      type,
      (value) => value?.type,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.versionKey,
      version,
      stringConverter,
    );

    IniUtils.setIniValue<String>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.nameKey,
      name.main,
      stringConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.genericNameKey,
      genericName?.main,
      stringConverter,
    );

    IniUtils.setIniValue<bool?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.noDisplayKey,
      noDisplay,
      booleanConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.commentKey,
      comment?.main,
      stringConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.iconKey,
      icon?.main,
      stringConverter,
    );

    IniUtils.setIniValue<bool?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.hiddenKey,
      hidden,
      booleanConverter,
    );

    IniUtils.setIniValue<List<String>?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.onlyShowInKey,
      onlyShowIn,
      listConverter,
    );

    IniUtils.setIniValue<List<String>?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.notShowInKey,
      notShowIn,
      listConverter,
    );

    IniUtils.setIniValue<bool?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.dbusActivatableKey,
      dbusActivatable,
      booleanConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.tryExecKey,
      tryExec,
      stringConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.execKey,
      exec,
      stringConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.pathKey,
      path,
      stringConverter,
    );

    IniUtils.setIniValue<bool?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.terminalKey,
      terminal,
      booleanConverter,
    );

    IniUtils.setIniValue<List<String>?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.actionsKey,
      actions,
      listConverter,
    );

    IniUtils.setIniValue<List<String>?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.mimeTypeKey,
      mimeType,
      listConverter,
    );

    IniUtils.setIniValue<List<String>?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.categoriesKey,
      categories,
      listConverter,
    );

    IniUtils.setIniValue<List<String>?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.implementsKey,
      implements,
      listConverter,
    );

    IniUtils.setIniValue<List<String>?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.keywordsKey,
      keywords,
      listConverter,
    );

    IniUtils.setIniValue<bool?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.startupNotifyKey,
      startupNotify,
      booleanConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.startupWmClassKey,
      startupWmClass,
      stringConverter,
    );

    IniUtils.setIniValue<String?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.urlKey,
      url,
      stringConverter,
    );

    IniUtils.setIniValue<bool?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.prefersNonDefaultGpuKey,
      prefersNonDefaultGpu,
      booleanConverter,
    );

    IniUtils.setIniValue<bool?>(
      ini,
      DesktopEntry.defaultSection,
      DesktopEntry.singleMainWindowKey,
      singleMainWindow,
      booleanConverter,
    );

    for (final DesktopEntryAction action in actionSections ?? []) {
      final String section = "Desktop Action ${action.id}";
      ini.addSection(section);

      IniUtils.setIniValue<String>(
        ini,
        section,
        DesktopEntry.nameKey,
        action.name.main,
        stringConverter,
      );

      IniUtils.setIniValue<String?>(
        ini,
        section,
        DesktopEntry.iconKey,
        action.icon?.main,
        stringConverter,
      );

      IniUtils.setIniValue<String?>(
        ini,
        section,
        DesktopEntry.execKey,
        action.exec,
        stringConverter,
      );
    }

    return ini;
  }

  static DesktopEntryType? getEntryType(
    Config ini,
    String key, {
    String group = defaultSection,
    bool optional = true,
  }) {
    final String? source = IniUtils.getValue(ini, key, group, optional);

    if (source == null) return null;

    switch (source) {
      case 'Application':
        return DesktopEntryType.application;
      case 'Link':
        return DesktopEntryType.link;
      case 'Directory':
        return DesktopEntryType.directory;
      case 'Service':
        return DesktopEntryType.service;
      case 'ServiceType':
        return DesktopEntryType.serviceType;
      case 'FSDevice':
        return DesktopEntryType.fsDevice;
      default:
        throw ValueCastException(
          requestedType: 'entry type',
          value: source,
          key: key,
          group: group,
          allowedValues: [
            'Application',
            'Link',
            'Directory',
            // KDE specific
            'Service',
            'ServiceType',
            'FSDevice',
          ],
        );
    }
  }
}

class DesktopEntryAction {
  final String id;
  final LocalizedString name;
  final LocalizedString? icon;
  final String? exec;

  const DesktopEntryAction({
    required this.id,
    required this.name,
    this.icon,
    this.exec,
  });

  @override
  int get hashCode => Object.hash(id, name, icon, exec);

  @override
  bool operator ==(Object other) {
    if (other is DesktopEntryAction) {
      return id == other.id &&
          name == other.name &&
          icon == other.icon &&
          exec == other.exec;
    }

    return false;
  }
}

enum DesktopEntryType {
  application("Application"),
  link("Link"),
  directory("Directory"),
  service("Service"),
  serviceType("ServiceType"),
  fsDevice("FSDevice");

  final String type;

  const DesktopEntryType(this.type);
}
