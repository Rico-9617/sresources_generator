import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

//image resources generator
Builder imageResourceBuilder(BuilderOptions options) => ImageResourceBuilder();

class ImageResourceBuilder extends Builder {
  late final Map<dynamic, dynamic> customConfig;
  Map<String, List<String>> extensions = {};

  ImageResourceBuilder() {
    final pubspecYamlString = File('pubspec.yaml').readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlString) as YamlMap;
    customConfig = pubspecYamlMap["sresources"] ?? {};

    final parent = customConfig['output'] ?? 'lib/gen/';
    extensions[r'$package$'] = [
      "${parent}images.res.dart",
    ];
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final content =
        await _generateImageClass(buildStep, customConfig['images']);

    if (content != null && content.isNotEmpty) {
      await buildStep.writeAsString(buildStep.allowedOutputs.single, content);
    }
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return extensions;
  }

// image class generate function
  Future<String?> _generateImageClass(
    BuildStep buildStep,
    Map<dynamic, dynamic>? config,
  ) async {
    if (!(config?['enabled'] ?? true)) return null;

    final imagesDir = Directory(config?['path'] ?? "assets/images/");
    if (await imagesDir.exists()) {
      String defaultThemeVal = config?['default']?.toString() ?? '0';
      final defaultTheme = StringBuffer();
      final otherThemes = StringBuffer();
      final resourceSettings = StringBuffer();
      final resourceFields = StringBuffer();

      final subFolderEntities = await imagesDir.list().toList();
      final subFolders = subFolderEntities.whereType<Directory>();
      String theme;
      String fileName;
      bool isDefault;
      for (var themeFolder in subFolders) {
        theme = themeFolder.path.split(Platform.pathSeparator).last;
        isDefault = theme == defaultThemeVal;
        if (!isDefault) {
          otherThemes.write('\n          "$theme" => {');
        }
        final subFileEntities = await themeFolder.list().toList();
        final files = subFileEntities.whereType<File>();
        for (var file in files) {
          fileName = file.uri.pathSegments.last.split(".")[0];
          if (isDefault) {
            defaultTheme.write('\n        "$fileName":"${file.path}",');
            resourceSettings.write('\n    _$fileName = null;');
            resourceFields.write('''\n\n  static String? _$fileName;
  static String get $fileName{
    _$fileName ??= _findResource("$fileName");
    return _$fileName!;
  }''');
          } else {
            otherThemes.write('\n         "$fileName":"${file.path}",');
          }
        }
        if (!isDefault) {
          otherThemes.write('\n         },');
        }
      }
      final className = config?['name'] ?? 'AppImages';
      return '''
//auto generate resource file classes

class $className{
  $className._();

  static String _theme = "$defaultThemeVal";
  
  static final Map<String, Map<String, String>> _themeResources = {};

  //default theme resources
  static Map<String, String>? _defaultRes;

  static Map<String, String> get _default {
    _defaultRes ??= {$defaultTheme
    };
    return _defaultRes!;
  }

  //add outter theme images
  static registerThemeResources(String theme, Map<String, String> resources) {
    _themeResources[theme] = resources;
  }

  //update theme and image resources
  static updateTheme(String theme) {
    _theme = theme;
    $resourceSettings
  }

  static String _findResource(String name){
    Map<String, String>? themeResources = _themeResources[_theme];
    if(themeResources == null) {
      themeResources = switch (_theme) {$otherThemes
        _ => _default,
      };
      _themeResources[_theme] = themeResources;
    }
    return themeResources[name] ?? _default[name] ?? "";
  }

  $resourceFields
}
      ''';
    }
    return null;
  }
}
