import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:flutter_gen_core/flutter_generator.dart';
import 'package:flutter_gen_core/generators/colors_generator.dart';
import 'package:flutter_gen_core/settings/config.dart';
import 'package:flutter_gen_core/utils/map.dart';
import 'package:sresources_generator/generator/_tools.dart';
import 'package:yaml/yaml.dart';

import '_color_resource_generator.dart';
import '_image_resource_generator.dart';
import '_language_generator.dart';

Builder sResourceBuilder(BuilderOptions options) => SResourceBuilder();

class SResourceBuilder extends Builder {
  final generator = FlutterGenerator(File('pubspec.yaml'));
  late final _config;
  late final customConfig;
  Map<String, List<String>> extensions = {};

  SResourceBuilder(){
    _config = loadPubspecConfigOrNull(generator.pubspecFile);
    final pubspecYamlString = generator.pubspecFile.readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlString) as YamlMap;
    final mergedMap = mergeMap([pubspecYamlMap]);
    customConfig = mergedMap["sresources"] ?? {};
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final results = await Future.wait([
      generateImageClass(buildStep, customConfig['images']),
      generateColorClass(buildStep, customConfig['colors']),
    ]);

    final imagesContent = results[0];
    final colorsContent = results[1];
    final getTextsContent = await generateGetLibTextsClass(buildStep, customConfig['languages_get']);

    await generator.build(
        config: _config,
        writer: (contents, path) {
          final parent = customConfig['output'] ?? 'lib/gen/';
          if(imagesContent != null && imagesContent.isNotEmpty) {
            buildStep.writeAsString(
                AssetId(buildStep.inputId.package, '${parent}images.gen.dart'),
                imagesContent);
          }
          if(colorsContent != null && colorsContent.isNotEmpty) {
            buildStep.writeAsString(
                AssetId(buildStep.inputId.package, '${parent}colors.gen.dart'),
                colorsContent);
          }
          if(getTextsContent != null && getTextsContent.isNotEmpty) {
            buildStep.writeAsString(
                AssetId(buildStep.inputId.package, '${parent}texts_get.gen.dart'),
                getTextsContent);
          }
        });
  }

  @override
  // TODO: implement buildExtensions
  Map<String, List<String>> get buildExtensions {
    if(extensions.isEmpty   ){
      final parent = customConfig['output'] ?? 'lib/gen/';
      extensions[r'$package$'] = [
        "${parent}images.gen.dart",
        "${parent}colors.gen.dart",
        "${parent}texts_get.gen.dart",
        "${parent}texts.gen.dart",
      ];
    }
    return extensions;
  }
}
