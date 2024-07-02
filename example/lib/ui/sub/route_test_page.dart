

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sresources_generator/public/app_route_get.dart';

@AppRouteGet(path: '/sresdemo/routeTestPage',name: 'routeTest',transition: GetTransition.upToDown)
class RouteTestPage extends StatelessWidget{
  const RouteTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ,
      child: Column(

      ),
    );
  }

}