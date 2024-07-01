import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sresources_generator/generator/_tools.dart';
import 'package:sresources_generator/public/app_route_get.dart';

class GetLibRouteGenerator {
  late bool enabled;
  late Resolver _resolver;
  late StringBuffer _importStr;
  late StringBuffer _fieldStr;
  late StringBuffer _getContentStr;
  late String className;

  GetLibRouteGenerator(BuildStep buildStep, Map<dynamic, dynamic> config) {
    enabled = config['enabled'] ?? true;
    if (enabled) {
      _fieldStr = StringBuffer();
      _getContentStr = StringBuffer();
      _importStr = StringBuffer();
      _resolver = buildStep.resolver;
      className = config['name'] ?? 'AppRoutes';
    }
  }

  parseAssetItem(AssetId assetId) async {
    if (!enabled) return;
    print(
        'Found annotated file: classElement ${assetId.package}   ${assetId.uri}   ${assetId.pathSegments}');
    final library = await _resolver.libraryFor(assetId);
    library.units.forEach((unit) {
      unit.classes.whereType<ClassElement>().forEach((classElement) {
        final annotation = TypeChecker.fromRuntime(AppRouteGet)
            .firstAnnotationOf(classElement);
        if (annotation != null) {
          _importStr.write("import '${assetId.uri}';\n");
          final annotationReader = ConstantReader(annotation);
          final nameValue = annotationReader.read('name');
          final name = nameValue.isNull
              ? convertToCamelCase(classElement.name)
              : nameValue.stringValue;
          _fieldStr.write('    static const $name = "${annotationReader.read('path').stringValue}";\n');
          final hasConstConstructor =
          classElement.constructors.any((constructor) => constructor.isConst);
          final getContent = StringBuffer(
              'GetPage(name:${name},page: ()=> ${hasConstConstructor ? 'const' : ''} ${classElement.name}(),');
          final transition = annotationReader.read('transition');
          if (!transition.isNull) {
            getContent.write('transition: ${transition.stringValue}');
          }
          getContent.write('),');
          _getContentStr.write('    ${getContent}\n');
        }
      });
    });
  }

  String? getContent() {
    if (!enabled) return null;
    if (_fieldStr.isNotEmpty && _getContentStr.isNotEmpty) {
      return '''
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

$_importStr

class $className{
  $className._();
  
$_fieldStr
  static final pages = [
$_getContentStr
  ];
}
    ''';
    }
    return null;
  }

}