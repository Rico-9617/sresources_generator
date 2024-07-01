import 'package:example/GlobalConfig.dart';
import 'package:example/Languages.dart';
import 'package:example/translations/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        locale: GlobalConfig.language.locale,
        translations: LocaleTranslations(),
        fallbackLocale: Languages.chineseSimplified.locale,
        home: const MyHomePage( ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){

              },
              child: Container(
                width: 200,
                height: 100,
                color: Colors.black26,
                alignment: Alignment.center,
                child: const Text("Theme test"),
              ),
            ),
            GestureDetector(
              onTap: (){

              },
              child: Container(
                width: 200,
                height: 100,
                color: Colors.brown,
                alignment: Alignment.center,
                child: const Text("Texts test"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
