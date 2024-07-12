import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:sresources_generator/generator/_tools.dart';
import 'package:sresources_generator/public.dart';
import 'package:yaml/yaml.dart';

//page route part generator for GetX
Builder getRoutesBuilder(BuilderOptions options) => GetRoutesBuilder();

class GetRoutesBuilder extends Builder {
  late Map<dynamic, dynamic> customConfig;
  Map<String, List<String>> extensions = {};

  GetRoutesBuilder() {
    final pubspecYamlString = File('pubspec.yaml').readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlString) as YamlMap;
    customConfig = pubspecYamlMap["sresources"]['routes_get'] ?? {};
    extensions['.dart'] = [
      ".get_route.part",
    ];
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (customConfig['enabled'] == false) return;

    final importStr = StringBuffer();
    final fieldStr = StringBuffer();
    final getContentStr = StringBuffer();
    final defaultTransition = customConfig['transition'];

    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    library.units.forEach((unit) {
      unit.classes.whereType().forEach((classElement) {
        ElementAnnotation? annotation =
            findAnnotation(classElement, AppRouteGet);
        if (annotation != null) {
          importStr.write("import '${buildStep.inputId.uri}';");
          final annotationValue = annotation.computeConstantValue();
          final nameValue = annotationValue?.getField('name')?.toStringValue();
          final name = nameValue == null
              ? convertToCamelCase(classElement.name)
              : nameValue;
          fieldStr.write(
              '  static const $name = "${annotationValue?.getField('path')?.toStringValue()}";');
          final hasConstConstructor = classElement.constructors
              .any((ConstructorElement constructor) => constructor.isConst);
          final getContent = StringBuffer(
              'GetPage(name:${name},page: ()=> ${hasConstConstructor ? 'const' : ''} ${classElement.name}(),');
          final transition =
              annotationValue?.getField('transition')?.toStringValue();
          final transitionValue =
              transition == null ? defaultTransition : transition;
          if (transitionValue != null && transitionValue.isNotEmpty) {
            getContent.write('transition: $transitionValue');
          }
          getContent.write('),');
          getContentStr.write('    ${getContent}');
        }
      });
    });
    if (fieldStr.isEmpty) return;
    await buildStep.writeAsString(buildStep.allowedOutputs.single,
        '$importStr$contentSeparator$fieldStr$contentSeparator$getContentStr');
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return extensions;
  }
}

//page route part combine builder for GetX
Builder getRoutesCombineBuilder(BuilderOptions options) =>
    GetRoutesCombineBuilder();

class GetRoutesCombineBuilder extends Builder {
  late Map<dynamic, dynamic> customConfig;
  Map<String, List<String>> extensions = {};

  GetRoutesCombineBuilder() {
    final pubspecYamlString = File('pubspec.yaml').readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlString) as YamlMap;
    customConfig = pubspecYamlMap["sresources"] ?? {};
    final parent = customConfig['output'] ?? 'lib/gen/';
    extensions[r'$package$'] = [
      "${parent}get_routes.route.dart",
    ];
    customConfig = customConfig['routes_get'] ?? {};
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (customConfig['enabled'] == false) return;
    final output = buildStep.allowedOutputs.single;
    final combined = await buildStep.findAssets(Glob(output.path));
    if (!(await combined.isEmpty)) return;

    final importStr = StringBuffer();
    final fieldStr = StringBuffer();
    final getContentStr = StringBuffer();

    final assetIds = buildStep.findAssets(Glob('lib/**'));
    await for (final assetId in assetIds) {
      if (!assetId.path.endsWith('.get_route.part')) continue;
      final contents =
          (await buildStep.readAsString(assetId)).split(contentSeparator);
      importStr.writeln(contents[0]);
      fieldStr.writeln(contents[1]);
      getContentStr.writeln(contents[2]);
    }
    if (fieldStr.isEmpty) return;

    final className = customConfig['name'] ?? 'AppRoutes';

    await buildStep.writeAsString(output,
        '''import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

$importStr

class $className{
  $className._();
  
$fieldStr
  static final pages = [
$getContentStr
  ];
}''');
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return extensions;
  }
}
