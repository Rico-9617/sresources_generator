//auto generate resource file classes
import 'dart:ui';

class AppColors{
  AppColors._();

  static String _theme ="0";
  
  static final Map<String, Map<String, Color>> _themeResources = {};

  //default theme resources
  static Map<String, Color>? _defaultRes;

  static Map<String, Color> get _default {
    _defaultRes ??= {
        "white":const Color(0xffFFFFFF),
        "black":const Color(0xff000000),
        "gray_70":const Color(0xffEEEEEE),
        "gray_410":const Color(0xff979797),
        "crimson_red":const Color(0xffCF2A2A),
        "yellow_ocher":const Color(0xffDF9527),
    };
    return _defaultRes!;
  }

  //add outter theme images
  static registerThemeResources(String theme, Map<String, Color> resources) {
    _themeResources[theme] = resources;
  }

  //update theme and image resources
  static updateTheme(String theme) {
    _theme = theme;
    
    _white = null;
    _black = null;
    _gray_70 = null;
    _gray_410 = null;
    _crimson_red = null;
    _yellow_ocher = null;
  }

  static Color _findResource(String name){
    Map<String, Color>? themeResources = _themeResources[_theme];
    if(themeResources == null) {
      themeResources = switch (_theme) {
          "1" => {
         "white":const Color(0xff000000),
         "black":const Color(0xffffffff),
         "gray_70":const Color(0xff333333),
         "gray_410":const Color(0xffdadada),
         },
        _ => _default,
      };
      _themeResources[_theme] = themeResources;
    }
    return themeResources[name] ?? _default[name] ?? const Color(0x00000000);
  }

  

  static Color? _white;
  static Color get white{
    _white ??= _findResource("white");
    return _white!;
  }

  static Color? _black;
  static Color get black{
    _black ??= _findResource("black");
    return _black!;
  }

  static Color? _gray_70;
  static Color get gray_70{
    _gray_70 ??= _findResource("gray_70");
    return _gray_70!;
  }

  static Color? _gray_410;
  static Color get gray_410{
    _gray_410 ??= _findResource("gray_410");
    return _gray_410!;
  }

  static Color? _crimson_red;
  static Color get crimson_red{
    _crimson_red ??= _findResource("crimson_red");
    return _crimson_red!;
  }

  static Color? _yellow_ocher;
  static Color get yellow_ocher{
    _yellow_ocher ??= _findResource("yellow_ocher");
    return _yellow_ocher!;
  }
}
      