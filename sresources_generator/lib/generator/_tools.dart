// change string like convert_to_camel_case to convertToCamelCase style
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';

const contentSeparator = '<~|~>';

String convertToCamelCase(String input) {
  List<String> segments = input.split('_');
  for (int i = 0; i < segments.length; i++) {
    segments[i] =
        (i == 0 ? segments[i][0].toLowerCase() : segments[i][0].toUpperCase()) +
            segments[i].substring(1);
  }
  return segments.join();
}

final exceptFields = {'hashCode', 'runtimeType'};

extension TypeJudge on DartType {
  bool isCustomClass() {
    final typeString = getDisplayString(withNullability: false);
    return !isDartCoreInt &&
        !isDartCoreDouble &&
        !isDartCoreNum &&
        !isDartCoreString &&
        !isDartCoreBool &&
        !isDartCoreList &&
        !isDartCoreMap &&
        !isDartCoreSet &&
        typeString != 'dynamic' &&
        typeString != 'Object';
  }

  String? getUri() {
    return element?.source?.uri.toString();
  }

  DartType? getGenericType() {
    if (this is ParameterizedType) {
      if ((this as ParameterizedType).typeArguments.isNotEmpty) {
        return (this as ParameterizedType).typeArguments[0];
      }
    }
    return null;
  }

  ({DartType key, DartType value})? getMapGenericType() {
    if (!isDartCoreMap) return null;
    if (this is ParameterizedType) {
      final pTypeArgs = (this as ParameterizedType).typeArguments;
      if (pTypeArgs.length == 2) {
        return (key: pTypeArgs[0], value: pTypeArgs[1]);
      }
    }
    return null;
  }

  bool isDartBaseType() {
    return element?.library?.isDartCore ?? false;
  }

  bool isDartBaseNonCollectionType() {
    return isDartBaseType() &&
        !isDartCoreList &&
        !isDartCoreMap &&
        !isDartCoreSet;
  }

  bool isDartCollectionType() {
    return isDartCoreList || isDartCoreMap || isDartCoreSet;
  }

  dynamic castBaseTypeFromDynamic(dynamic value) {
    if (value == null) {
      if (isDartCoreBool) return false;
      if (isDartCoreInt) return 0;
      if (isDartCoreDouble) return 0.0;
      if (isDartCoreString) return '';
      if (isDartCoreList) return [];
      if (isDartCoreMap) return {};
      return null;
    } else {
      if (isDartCoreBool && value is bool) return value;
      if (isDartCoreInt && value is int) return value;
      if (isDartCoreDouble && value is double) return value;
      if (isDartCoreString && value is String) return value;
      if (isDartCoreList && value is List) return value;
      if (isDartCoreMap && value is Map) return value;
      return null;
    }
  }

  dynamic get defaultValue {
    if (isDartCoreBool) return false;
    if (isDartCoreInt) return 0;
    if (isDartCoreDouble) return 0.0;
    if (isDartCoreString) return '';
    if (isDartCoreList) return [];
    if (isDartCoreMap) return {};
    return null;
  }

  bool isNullable() {
    return nullabilitySuffix == NullabilitySuffix.question;
  }
}

bool annotationIsType(ElementAnnotation element, Type type) {
  final typeName = type.toString();
  return element.element?.displayName == typeName ||
      element.element?.name == typeName;
}

ElementAnnotation? findAnnotation(Element element, Type type) {
  final typeName = type.toString();
  ElementAnnotation? annotation;
  for (final e in element.metadata) {
    if ((e.element?.displayName == typeName || e.element?.name == typeName)) {
      annotation = e;
      break;
    }
  }
  return annotation;
}

ElementAnnotation? findAnnotationByName(Element element, String type) {
  ElementAnnotation? annotation;
  for (final element in element.metadata) {
    if ((element.element?.displayName == type ||
        element.element?.name == type)) {
      annotation = element;
      break;
    }
  }
  return annotation;
}

extension AssetIdExt on AssetId {
  String get name {
    final fileName = pathSegments.last;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1) {
      return fileName.substring(0, dotIndex);
    }
    return fileName;
  }
}
