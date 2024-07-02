import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:sresources_generator/generator/_tools.dart';

// page class route generate class for GetX
class GetLibRouteGenerator {
  late bool enabled;
  late Resolver _resolver;
  late StringBuffer _importStr;
  late StringBuffer _fieldStr;
  late StringBuffer _getContentStr;
  late String className;
  late String? defaultTransition;

  GetLibRouteGenerator(BuildStep buildStep, Map<dynamic, dynamic>? config) {
    enabled = config?['enabled'] ?? true;
    if (enabled) {
      _fieldStr = StringBuffer();
      _getContentStr = StringBuffer();
      _importStr = StringBuffer();
      _resolver = buildStep.resolver;
      className = config?['name'] ?? 'AppRoutes';
      defaultTransition = config?['transition'];
    }
  }

  parseAssetItem(AssetId assetId) async {
    if (!enabled) return;
    final library = await _resolver.libraryFor(assetId);
    library.units.forEach((unit) {
      unit.classes.whereType().forEach((classElement) {
        ElementAnnotation? annotation = null;
        for(final element in classElement.metadata) {
          if(element is ElementAnnotation && (element.element?.displayName == 'AppRouteGet' || element.element?.name == 'AppRouteGet' )) {
            annotation = element;
            break;
          }
        }
        if (annotation != null) {
          _importStr.write("import '${assetId.uri}';\n");
          final annotationValue = annotation.computeConstantValue();
          final nameValue = annotationValue?.getField('name')?.toStringValue();
          final name = nameValue == null
              ? convertToCamelCase(classElement.name)
              : nameValue;
          _fieldStr.write('  static const $name = "${annotationValue?.getField('path')?.toStringValue()}";\n');
          final hasConstConstructor = classElement.constructors.any((ConstructorElement constructor) => constructor.isConst);
          final getContent = StringBuffer(
              'GetPage(name:${name},page: ()=> ${hasConstConstructor ? 'const' : ''} ${classElement.name}(),');
          final transition = annotationValue?.getField('transition')?.toStringValue();
          final transitionValue = transition == null ? defaultTransition : transition;
          if (transitionValue != null && transitionValue.isNotEmpty) {
            getContent.write('transition: $transitionValue');
          }
          getContent.write('),');
          _getContentStr.write('    ${getContent}\n');
        }
      });
    });
  }

  // get final class content
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