import 'package:build/build.dart';

//clean temp part files
PostProcessBuilder sCleanUpBuilder(BuilderOptions options) =>
    FileDeletingBuilder(['.get_route.part', '.get_texts.part']);
