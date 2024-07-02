// GetX route generate annotation
class AppRouteGet {
  final String path;
  final String? name; //if null(default) then generator will use Class name as the name of the route field
  final String? transition; //just pass Transition.rightToLeft.toString()

  const AppRouteGet({
    required this.path,
    this.name = null,
    this.transition = null,
  });
}

// GetX page shown animation
class GetTransition {
  GetTransition._();

  static const fade = "Transition.fade";
  static const fadeIn = "Transition.fadeIn";
  static const rightToLeft = "Transition.rightToLeft";
  static const leftToRight = "Transition.leftToRight";
  static const upToDown = "Transition.upToDown";
  static const downToUp = "Transition.downToUp";
  static const rightToLeftWithFade = "Transition.rightToLeftWithFade";
  static const leftToRightWithFade = "Transition.leftToRightWithFade";
  static const zoom = "Transition.zoom";
  static const topLevel = "Transition.topLevel";
  static const noTransition = "Transition.noTransition";
  static const cupertino = "Transition.cupertino";
  static const cupertinoDialog = "Transition.cupertinoDialog";
  static const size = "Transition.size";
  static const circularReveal = "Transition.circularReveal";
  static const native = "Transition.native";
}
