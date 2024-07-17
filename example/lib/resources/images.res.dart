//auto generate resource file classes

class TestImages{
  TestImages._();

  static String _theme = "0";
  
  static final Map<String, Map<String, String>> _themeResources = {};

  //default theme resources
  static Map<String, String>? _defaultRes;

  static Map<String, String> get _default {
    _defaultRes ??= {
        "world": "assets/images/0/world.png",
        "home": "assets/images/0/home.png",
        "picture": "assets/images/0/picture.png",
    };
    return _defaultRes!;
  }

  //add outter theme images
  static registerThemeResources(String theme, Map<String, String> resources) {
    _themeResources[theme] = resources;
  }

  //update theme and image resources
  static updateTheme(String theme) {
    _theme = theme;
    
    _world = null;
    _home = null;
    _picture = null;
  }

  static String _findResource(String name){
    Map<String, String>? themeResources = _themeResources[_theme];
    if(themeResources == null) {
      themeResources = switch (_theme) {
          "1" => {
         "world": "assets/images/1/world.png",
         "home": "assets/images/1/home.png",
         "picture": "assets/images/1/picture.png",
         },
        _ => _default,
      };
      _themeResources[_theme] = themeResources;
    }
    return themeResources[name] ?? _default[name] ?? "";
  }

  

  static String? _world;
  static String get world{
    _world ??= _findResource("world");
    return _world!;
  }

  static String? _home;
  static String get home{
    _home ??= _findResource("home");
    return _home!;
  }

  static String? _picture;
  static String get picture{
    _picture ??= _findResource("picture");
    return _picture!;
  }
}
      