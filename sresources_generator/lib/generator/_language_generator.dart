import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:sresources_generator/generator/_tools.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sresources_generator/public/app_language_texts.dart';

Future<String?> generateGetLibTextsClass(
  BuildStep buildStep,
  Map<dynamic, dynamic> config,
) async {
  if (!(config['enabled'] ?? true)) return null;
  final sourcePath = config['source']?.toString();
  String sourceString = "";
  if (sourcePath != null && sourcePath.isNotEmpty) {
    final file = File(sourcePath);
    if (await file.exists()) {
      try {
        sourceString = await file.readAsString();
      } catch (e) {
        print('Error reading file: $e');
      }
    }
  }
  if (sourceString.isEmpty) {
    final assetIds = buildStep.findAssets(Glob('lib/**/*.dart'));
    await for (final assetId in assetIds) {
      final assetContent = await buildStep.readAsString(assetId);

      if (assetContent.contains('AppTextsSource')) {
        print('Found annotated file: ${assetId.path}');
        sourceString = assetContent;
      }
    }
  }
  if (sourceString.isEmpty) return null;

  final regex = RegExp(r"Map<[^>]+>\s*(\w+)\s*=\s*{");
  final content = StringBuffer();

  final match = regex.firstMatch(sourceString);
  if (match != null) {
    final endIndex = match.end; // Get the end index of the matched string
    sourceString =
        sourceString.substring(endIndex + 1, sourceString.lastIndexOf("}"));
    final languageRegex = RegExp(
        r'''["']([^"]+)['"]\s*:\s*r?(("{3}(.*?)"{3})|('{3}(.*?)'{3})|("[^"]+")|('[^']+')),?''',
        multiLine: true, dotAll: true);
    final patternRegex = RegExp(r'@{([^}]+)}');
    final languageMatch = languageRegex.allMatches(sourceString);
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
        content.write(
            '\n static String get ${convertToCamelCase(key)} => "$key".tr;');
      } else {
        content.write(
            '\n static String ${convertToCamelCase(key)}($patternParameterBuffer) => "$key".trParams({$patternMapBuffer});');
      }
    }
    final className = config['name'] ?? 'AppTexts';
    return '''
import 'package:get/get.dart';

class $className{
  $className._();
$content
}
      ''';
  }
  return null;
}

Builder getLanguageBuilder(BuilderOptions options) => GetLanguageBuilder();

class GetLanguageBuilder extends Builder {
  final _generator = GetLanguageGenerator();

  @override
  Future<void> build(BuildStep buildStep) async {
    print("testlanbuild ${buildStep.inputId.path}");
    final libraryElement =
        await buildStep.resolver.libraryFor(buildStep.inputId);
    final generatedCode =
        await _generator.generate(LibraryReader(libraryElement), buildStep);
    await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, 'lib/gen/app_texts.tr.dart'),
        generatedCode);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'lib/translations/zh_cn.dart': [
          'lib/gen/app_texts.tr.dart',
        ]
      };
}

class GetLanguageGenerator extends GeneratorForAnnotation<AppTextsSource> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    String fileContents = await buildStep.readAsString(buildStep.inputId);
    final regex = RegExp(r"Map<[^>]+>\s*(\w+)\s*=\s*{");
    final output = StringBuffer();
    final content = StringBuffer();

    final match = regex.firstMatch(fileContents);
    if (match != null) {
      final endIndex = match.end; // Get the end index of the matched string
      fileContents =
          fileContents.substring(endIndex + 1, fileContents.lastIndexOf("}"));
      final languageRegex = RegExp(
          r'''["']([^"]+)['"]\s*:\s*r?(("{3}(.*?)"{3})|('{3}(.*?)'{3})|("[^"]+")|('[^']+')),?''',
          multiLine: true, dotAll: true);
      final patternRegex = RegExp(r'@{([^}]+)}');
      final languageMatch = languageRegex.allMatches(fileContents);
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
          content.write(
              '\n static String get ${convertToCamelCase(key)} => "$key".tr;');
        } else {
          content.write(
              '\n static String ${convertToCamelCase(key)}($patternParameterBuffer) => "$key".trParams({$patternMapBuffer});');
        }
      }
      output.write('''
import 'package:get/get.dart';

class AppTexts{
$content
}
      ''');
    } else {
      return null;
    }

    return '''
      $output
    ''';
  }
}
