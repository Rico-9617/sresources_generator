
import 'dart:ui';

enum Languages{
  chineseSimplified(value: "zh_CN",locale: Locale('zh', 'CN')),
  chineseTraditional(value: "zh_TW",locale: Locale('zh', 'TW')),
  english(value: "en_US",locale: Locale('en', 'US')),
  ;

  final String value;
  final Locale locale;
  const Languages({required this.value,required this.locale});

}