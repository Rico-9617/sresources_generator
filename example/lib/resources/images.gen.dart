//auto generate resource file classes

class TestImages{
  TestImages._();

  static String _theme = "0";
  
  static final Map<String, Map<String, String>> _themeResources = {};

  //default theme resources
  static Map<String, String>? _defaultRes;

  static Map<String, String> get _default {
    _defaultRes ??= {
        "dx_game_tg":"assets/images/0/dx_game_tg.png",
        "Group":"assets/images/0/Group.png",
        "test_qwer1":"assets/images/0/test_qwer1.png",
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
    
    _dx_game_tg = null;
    _Group = null;
    _test_qwer1 = null;
  }

  static String _findResource(String name){
    Map<String, String>? themeResources = _themeResources[_theme];
    if(themeResources == null) {
      themeResources = switch (_theme) {
          "1" => {
         "dx_game_tg":"assets/images/1/dx_game_tg.png",
         "test_qwer1":"assets/images/1/test_qwer1.png",
         },
        _ => _default,
      };
      _themeResources[_theme] = themeResources;
    }
    return themeResources[name] ?? _default[name] ?? "";
  }

  

  static String? _dx_game_tg;
  static String get dx_game_tg{
    _dx_game_tg ??= _findResource("dx_game_tg");
    return _dx_game_tg!;
  }

  static String? _Group;
  static String get Group{
    _Group ??= _findResource("Group");
    return _Group!;
  }

  static String? _test_qwer1;
  static String get test_qwer1{
    _test_qwer1 ??= _findResource("test_qwer1");
    return _test_qwer1!;
  }
}
      