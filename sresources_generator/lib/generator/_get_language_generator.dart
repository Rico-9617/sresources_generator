import 'dart:io';

import 'package:build/build.dart';
import 'package:sresources_generator/generator/_tools.dart';

// i18n generate for GetX
class GetLibTextsGenerator {
  late bool enabled;
  late BuildStep _buildStep;
  late StringBuffer _fieldStr;
  late String className;

  bool _contentCompleted = false;

  GetLibTextsGenerator(
    BuildStep buildStep,
    Map<dynamic, dynamic>? config,
  ) {
    enabled = config?['enabled'] ?? true;
    if (enabled) {
      className = config?['name'] ?? 'AppTexts';
      _fieldStr = StringBuffer();
      final sourcePath = config?['source']?.toString();
      String sourceString = "";
      if (sourcePath != null && sourcePath.isNotEmpty) {
        final file = File(sourcePath);
        if (file.existsSync()) {
          try {
            sourceString = file.readAsStringSync();
          } catch (e) {
            print('Error reading file: $e');
          }
        }
      }
      if (sourceString.isNotEmpty) {
        _contentCompleted = true;
        _parseContent(sourceString);
      } else {
        _buildStep = buildStep;
      }
    }
  }

  // parse each item scanned by builder
  parseAssetItem(AssetId assetId) async {
    if (!enabled || _contentCompleted) return;

    final assetContent = await _buildStep.readAsString(assetId);

    if (assetContent.contains('AppTextsSource')) {
      _contentCompleted = true;
      _parseContent(assetContent);
    }
  }

  _parseContent(String content) {
    final regex = RegExp(r"Map<[^>]+>\s*(\w+)\s*=\s*{");

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
          _fieldStr.write(
              '\n static String get ${convertToCamelCase(key)} => "$key".tr;');
        } else {
          _fieldStr.write(
              '\n static String ${convertToCamelCase(key)}($patternParameterBuffer) => "$key".trParams({$patternMapBuffer});');
        }
      }
    }
  }

  // get final class content
  String? getContent() {
    if (!enabled || _fieldStr.isEmpty) return null;

    return '''
import 'package:get/get.dart';

class $className{
  $className._();
$_fieldStr
}
      ''';
  }
}
