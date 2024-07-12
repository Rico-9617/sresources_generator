import 'dart:async';

import 'package:build/build.dart';

Builder jsonSerializerBuilder(BuilderOptions options) {
  return JsonSerializerBuilder();
}

class JsonSerializerBuilder extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
//     final library = await buildStep.resolver.libraryFor(buildStep.inputId);
//     StringBuffer contentBuffer = StringBuffer();
//     for (var unit in library.units) {
//       for (var classElement in unit.classes.whereType()) {
//         final annotation = findAnnotation(classElement,JSONClass);
//         final annotationValue = annotation?.computeConstantValue();
//         if(annotationValue == null) continue;
//
//         final allFields = <FieldElement>[];
//         ClassElement? currentClass = classElement;
//         while (currentClass != null) {
//           for (final field in currentClass.fields) {
//             if (field.isStatic || exceptFields.contains(field.name)) {
//               continue;
//             }
//             allFields.add(field);
//           }
//           currentClass = currentClass.supertype?.element as ClassElement?;
//         }
//         if (allFields.isEmpty) continue;
//         final className = classElement.name;
//         final fromJSONBuffer = StringBuffer(
//             '\n$className _${className}FromJson(Map<String,dynamic> json){');
//         fromJSONBuffer.writeln('  return $className(');
//         contentBuffer.writeln('''
// extension ${className}JSON on $className{
// ''');
//         final toJSONBuffer = StringBuffer(' Map<String,dynamic> toJson(){');
//         toJSONBuffer.writeln('  return {');
//         for (final field in allFields) {
//           final fieldName = field.name;
//           final isNullable =
//               field.type.nullabilitySuffix == NullabilitySuffix.question;
//           final jsonFieldAnnotation = findAnnotation(field,JSONField);
//           final jsonFieldReader = jsonFieldAnnotation?.computeConstantValue();
//           final fieldType = field.type;
//           if (fieldType.isDartCoreInt) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is int ? json['$fieldName'] : ${isNullable && jsonFieldReader == null ? 'null' : jsonFieldReader != null ? jsonFieldReader.getField('defaultValue')!.toIntValue() : '0'},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           } else if (fieldType.isDartCoreDouble) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is double ? json['$fieldName'] :  ${isNullable && jsonFieldReader == null ? 'null' : jsonFieldReader != null ? jsonFieldReader.getField('defaultValue')!.toDoubleValue() : '0.0'},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           }  else if (fieldType.isDartCoreNum) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is num ? json['$fieldName'] :  ${isNullable && jsonFieldReader == null ? 'null' : jsonFieldReader != null ? jsonFieldReader.getField('defaultValue')!.toDoubleValue() : '0.0'},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           } else if (fieldType.isDartCoreString) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is String ? json['$fieldName'] :  ${isNullable && jsonFieldReader == null ? 'null' : jsonFieldReader != null ? '\'${jsonFieldReader.getField('defaultValue')!.toStringValue()}\'' : '\'\''},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           } else if (fieldType.isDartCoreBool) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is bool ? json['$fieldName'] :  ${isNullable && jsonFieldReader == null ? 'null' : jsonFieldReader != null ? jsonFieldReader.getField('defaultValue')!.toBoolValue() : 'false'},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           } else if (fieldType.isDartCoreList) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is List ? json['$fieldName'] :  ${isNullable ? 'null' : '[]'},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           } else if (fieldType.isDartCoreMap) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is Map ? json['$fieldName'] :  ${isNullable ? 'null' : '{}'},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           } else if (fieldType.isDartCoreSet) {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] is Set ? json['$fieldName'] :  ${isNullable ? 'null' : '{}'},");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           } else if (fieldType.isCustomClass()) {
//             final typeString = field.type.getDisplayString(withNullability: false);
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'] == null ? null :  $typeString.fromJson(json['$fieldName']),");
//             toJSONBuffer.writeln(
//                 "   '$fieldName':  $fieldName${isNullable ? '?' : ''}.toJson(),");
//           } else {
//             fromJSONBuffer.writeln(
//                 "   $fieldName: json['$fieldName'],");
//             toJSONBuffer.writeln("    '$fieldName': $fieldName,");
//           }
//         }
//         fromJSONBuffer.writeln('  );');
//         fromJSONBuffer.writeln('}');
//         toJSONBuffer.writeln('    };');
//         toJSONBuffer.writeln('  }');
//         contentBuffer.writeln(toJSONBuffer);
//         contentBuffer.writeln('}\n');
//         contentBuffer.writeln(fromJSONBuffer);
//       }
//     }
//     if(contentBuffer.isEmpty) return;
//
//     final outputId = buildStep.allowedOutputs.single;
//
//     await buildStep.writeAsString(outputId, '''
// part of '${buildStep.inputId.pathSegments.last}';
//
// $contentBuffer
//     ''');
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      '.dart': ['.json.dart']
    };
  }
}
