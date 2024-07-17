import 'package:get/get.dart';

class AppTexts{
  AppTexts._();

 static String get helloBlankFragment => "hello_blank_fragment".tr;
 static String get helloBlankFragment2 => "hello_blank_fragment2".tr;
 static String get helloBlankFragment3 => "hello_blank_fragment3".tr;
 static String get helloBlankFragment4 => "hello_blank_fragment4".tr;
 static String helloBlankFragment1(String test1,String test2,) => "hello_blank_fragment1".trParams({"{test1}":test1,"{test2}":test2,});
 static String get helloBlankFragment5 => "hello_blank_fragment5".tr;
 static String get helloBlankFragment6 => "hello_blank_fragment6".tr;
 static String helloBlankFragment7(String name,) => "hello_blank_fragment7".trParams({"{name}":name,});
 static String get helloBlankFragment9 => "hello_blank_fragment9".tr;
 static String helloBlankFragment10(String test,) => "hello_blank_fragment10".trParams({"{test}":test,});
 static String get helloBlankFragment11 => "hello_blank_fragment11".tr;
}