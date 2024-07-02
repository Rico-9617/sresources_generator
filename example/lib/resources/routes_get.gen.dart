import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import 'package:example/ui/text_test_page.dart';
import 'package:example/ui/sub/route_test_page.dart';
import 'package:example/theme_test_page.dart';


class TestRoutes{
  TestRoutes._();
  
    static const TextTest = "/sresdemo/textTestPage";
    static const routeTest = "/sresdemo/routeTestPage";
    static const themeTestPage = "/sresdemo/themeTest";

  static final pages = [
    GetPage(name:TextTest,page: ()=> const TextTestPage(),transition: Transition.rightToLeft),
    GetPage(name:routeTest,page: ()=> const RouteTestPage(),transition: Transition.upToDown),
    GetPage(name:themeTestPage,page: ()=>  ThemeTestPage(),transition: Transition.rightToLeft),

  ];
}
    