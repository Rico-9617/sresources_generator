import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:sresources_generator/generator/_tools.dart';
import 'package:yaml/yaml.dart';

//Text resource generator for GetX
Builder getTextResourceBuilder(BuilderOptions options) =>
    GetTextResourceBuilder();

class GetTextResourceBuilder extends Builder {
  late Map<dynamic, dynamic> customConfig;
  Map<String, List<String>> extensions = {};

  GetTextResourceBuilder() {
    final pubspecYamlString = File('pubspec.yaml').readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlString) as YamlMap;
    customConfig = pubspecYamlMap["sresources"]['languages_get'] ?? {};

    extensions['.dart'] = [
      ".get_texts.part",
    ];
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (customConfig['enabled'] == false) return;
    String content = '';
    String fileContent = await buildStep.readAsString(buildStep.inputId);
    if (fileContent.contains('@AppTextsSource()')) {
      content = _parseContent(fileContent, customConfig['name'] ?? 'AppTexts');
    }

    if (content.isNotEmpty) {
      await buildStep.writeAsString(buildStep.allowedOutputs.single, content);
    }
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return extensions;
  }

  String _parseContent(String content, String className) {
    final regex = RegExp(r"Map<[^>]+>\s*(\w+)\s*=\s*{");
    final contentBuffer = StringBuffer();

    final match = regex.firstMatch(content);
    if (match != null) {
      final endIndex = match.end; // Get the end index of the matched string
      content = content.substring(endIndex + 1, content.lastIndexOf("}"));
      final languageRegex = RegExp(
          r'''["']([^"]+)['"]\s*:\s*r?(("{3}(.*?)"{3})|('{3}(.*?)'{3})|("[^"]+")|('[^']+')),?''',
          multiLine: true, dotAll: true);
      final patternRegex = RegExp(r'@{([^}]+)}');
      final languageMatch = languageRegex.allMatches(content);
      String key, value;
      Iterable<RegExpMatch> patternMatch;
      for (final match in languageMatch) {
        key = match.group(1)!;
        value = match.group(2)!;
        patternMatch = patternRegex.allMatches(value);
        final patternParameterBuffer = StringBuffer(),
            patternMapBuffer = StringBuffer();
        String? pattern;
        for (final patternItem in patternMatch) {
          pattern = patternItem.group(1);
          if (pattern?.isNotEmpty != true) continue;
          patternParameterBuffer.write("String $pattern,");
          patternMapBuffer.write('"{$pattern}":$pattern,');
        }
        if (patternParameterBuffer.isEmpty) {
          contentBuffer.write(
              '\n static String get ${convertToCamelCase(key)} => "$key".tr;');
        } else {
          contentBuffer.write(
              '\n static String ${convertToCamelCase(key)}($patternParameterBuffer) => "$key".trParams({$patternMapBuffer});');
        }
      }
    }
    return '''
import 'package:get/get.dart';

class $className{
  $className._();
$contentBuffer
}''';
  }
}

//Text resource final confirm generator for GetX
Builder getTextsResourceConfirmBuilder(BuilderOptions options) =>
    GetTextsResourceConfirmBuilder();

class GetTextsResourceConfirmBuilder extends Builder {
  late Map<dynamic, dynamic> customConfig;
  Map<String, List<String>> extensions = {};

  GetTextsResourceConfirmBuilder() {
    final pubspecYamlString = File('pubspec.yaml').readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlString) as YamlMap;
    customConfig = pubspecYamlMap["sresources"] ?? {};
    final parent = customConfig['output'] ?? 'lib/gen/';
    extensions[r'$package$'] = [
      "${parent}get_texts.res.dart",
    ];
    customConfig = customConfig['languages_get'] ?? {};
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (customConfig['enabled'] == false) return;

    final output = buildStep.allowedOutputs.single;
    final combined = await buildStep.findAssets(Glob(output.path));
    if (!(await combined.isEmpty)) return;
    final assetIds = buildStep.findAssets(Glob('lib/**'));
    String content = '';
    await for (final assetId in assetIds) {
      if (!assetId.path.endsWith('.get_texts.part')) continue;
      content = await buildStep.readAsString(assetId);
      break;
    }
    if (content.isEmpty) return;
    await buildStep.writeAsString(output, content);
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return extensions;
  }
}
