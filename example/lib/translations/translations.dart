
import 'package:example/translations/zh_cn.dart';
import 'package:example/translations/zh_tw.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'en.dart';


class LocaleTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': localeZH_CN,
    'zh_TW': localeZH_TW,
    'en': localeEN,
    // 'ko_KR': localeKR,
  };
}

