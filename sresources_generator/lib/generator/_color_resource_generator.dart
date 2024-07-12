import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:xml2json/xml2json.dart';
import 'package:yaml/yaml.dart';

//color resources generator
Builder colorResourceBuilder(BuilderOptions options) => ColorResourceBuilder();

class ColorResourceBuilder extends Builder {
  late final Map<dynamic, dynamic> customConfig;
  Map<String, List<String>> extensions = {};

  ColorResourceBuilder() {
    final pubspecYamlString = File('pubspec.yaml').readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlString) as YamlMap;
    customConfig = pubspecYamlMap["sresources"] ?? {};

    final parent = customConfig['output'] ?? 'lib/gen/';
    extensions[r'$package$'] = [
      "${parent}colors.res.dart",
    ];
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final colorsContent =
        await _generateColorClass(buildStep, customConfig['colors']);

    if (colorsContent != null && colorsContent.isNotEmpty) {
      await buildStep.writeAsString(
          buildStep.allowedOutputs.single, colorsContent);
    }
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return extensions;
  }

// color generate function
  Future<String?> _generateColorClass(
    BuildStep buildStep,
    Map<dynamic, dynamic>? config,
  ) async {
    if (!(config?['enabled'] ?? true)) return null;
    final assetReader = buildStep
        .findAssets(Glob('${config?['path'] ?? 'assets/color/'}*.xml'));
    final xml2Json = Xml2Json();
    String defaultThemeVal = config?['default']?.toString() ?? '0';
    final defaultTheme = StringBuffer();
    final otherThemes = StringBuffer();
    final resourceSettings = StringBuffer();
    final resourceFields = StringBuffer();

    Map<String, dynamic> json;
    String colorName, value;
    await for (final assetId in assetReader) {
      final assetContent = await buildStep.readAsString(assetId);
      final theme = assetId.pathSegments.last.split('.')[0];
      final isDefault = theme == defaultThemeVal;
      xml2Json.parse(assetContent);
      json = jsonDecode(xml2Json.toParkerWithAttrs());
      if (!isDefault) {
        otherThemes.write('\n          "$theme" => {');
      }

      // print("buildtest ${xml2Json.toParkerWithAttrs()}");
      // print("buildtest ${json['resources']}  ${json['resources']['color']}");
      for (var entry in json['resources']['color']) {
        colorName = entry['_name'];
        value = entry['value'].replaceFirst('#', '');
        if (value.length == 6) {
          value = '0xff$value';
        } else {
          value = '0x$value';
        }
        if (isDefault) {
          defaultTheme.write('\n        "$colorName":const Color($value),');
          resourceSettings.write('\n    _$colorName = null;');
          resourceFields.write('''\n\n  static Color? _$colorName;
  static Color get $colorName{
    _$colorName ??= _findResource("$colorName");
    return _$colorName!;
  }''');
        } else {
          otherThemes.write('\n         "$colorName":const Color($value),');
        }
      }
      if (!isDefault) {
        otherThemes.write('\n         },');
      }
    }
    if (defaultTheme.isNotEmpty) {
      final className = config?['name'] ?? 'AppColors';
      return '''
//auto generate resource file classes
import 'dart:ui';

class $className{
  $className._();

  static String _theme ="$defaultThemeVal";
  
  static final Map<String, Map<String, Color>> _themeResources = {};

  //default theme resources
  static Map<String, Color>? _defaultRes;

  static Map<String, Color> get _default {
    _defaultRes ??= {$defaultTheme
    };
    return _defaultRes!;
  }

  //add outter theme images
  static registerThemeResources(String theme, Map<String, Color> resources) {
    _themeResources[theme] = resources;
  }

  //update theme and image resources
  static updateTheme(String theme) {
    _theme = theme;
    $resourceSettings
  }

  static Color _findResource(String name){
    Map<String, Color>? themeResources = _themeResources[_theme];
    if(themeResources == null) {
      themeResources = switch (_theme) {$otherThemes
        _ => _default,
      };
      _themeResources[_theme] = themeResources;
    }
    return themeResources[name] ?? _default[name] ?? const Color(0x00000000);
  }

  $resourceFields
}
      ''';
    }
    return null;
  }
}
