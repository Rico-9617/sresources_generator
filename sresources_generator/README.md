A generator for colors,images,language texts etc.<br>
Can adjust to GetX library.<br>
Learnt from flutter_gen source_gen.<br>

#### 1、image files:
Just put under project_root/assets/image/(dark|light) folder, dark and light stands for two themes, so that can add other theme folders, and the name can customize.<br>
Note that need add sub folders to the pubspec.yaml, or sub folders won't be build into packages.<br>
The name of picture of each theme should be the same.<br>
If a image doesn't exist in a specific theme folder, it will auto use the version in default theme folder which configured in pubspec.yaml when use the theme.<br> 

#### 2、color resources:
Create a sub folder of assets named color(or else, but should configure in the pubspec.yaml as below tutorial shows), and then can create xxx.xml file, the file name better according to your theme's value(like the dark/light folder under image folder).<br>
And then, add colors in your xxx.xml just like Android color xml format:<br>
If a color doesn't exist in the specific color xml, it will auto use the version in default theme xml which configured in pubspec.yaml when use the theme.<br>

    <?xml version="1.0" encoding="utf-8"?>
    <resources>
        <color name="white">#FFFFFF</color>
        <color name="black">#000000</color>
        <color name="gray_70">#EEEEEE</color>
        <color name="gray_410">#979797</color>
        <color name="crimson_red" type="material">#CF2A2A</color>
        <color name="yellow_ocher" type="material material-accent">#DF9527</color>
    </resources>


#### 3、text resources:
##### 1). for GetX:
The language text contents will be like:<br>

    @AppTextsSource()
    Map<String,String>  localeZH_CN={
        "hello_blank_fragment":"简中Hello blank fragment\",\"",
        "hello_blank_fragment2":r'"简中Hello blank fragment",""',
        "hello_blank_fragment3":  "简中Hello blank\n, fragment",
        "hello_blank_fragment4" :'简中Hello blank\n, fragment',
        "hello_blank_fragment1"   :  "简中Hello@{test1} blank @{test2} fragment",
        "hello_blank_fragment5"   :  '''简中Hello blank fragment5''',
        "hello_blank_fragment6"   :  r'''简中Hello blank 'fragment6''',
        "hello_blank_fragment7"   :  r'''简中Hello
        blank ' "
        test @{name}
        f'ragment''',
        "hello_blank_fragment9" :'简中Hello blank, @name fragment9',
        "hello_blank_fragment10" :r'简中Hello blank, @{test}fragment10',
        "hello_blank_fragment11"   :  """简中Hello
        blank ; ' "
        fragment""",
        };


@AppTextsSource() use to tag this map for generating, can also by add path of this file to the pubspec.yaml to specify.<br>
@{test1} and other string in this format(@{...}) are the patterns which can be replaced with real values when use, after generating, test1 will become the parameter of the text get function.<br>


#### 3、text resources:
##### 1). for GetX:
Add annotations to your page class like:

    @AppRouteGet(path: '/sresdemo/routeTestPage',name: 'routeTest',transition: GetTransition.rightToLeft)

Name will use as the name of this route field, and transition is the page shown animation according to GetX.
After generation you will get a class like:

    class TestRoutes{
        TestRoutes._();

        static const TextTest = "/sresdemo/textTestPage";
        static const routeTest = "/sresdemo/routeTestPage";
        static const themeTestPage = "/sresdemo/themeTest";

        static final pages = [
            GetPage(name:TextTest,page: ()=> const TextTestPage(),),
            GetPage(name:routeTest,page: ()=> const RouteTestPage(),transition: Transition.rightToLeft),
            GetPage(name:themeTestPage,page: ()=>  ThemeTestPage(),),

        ];
    }

TestRoutes is a name configured in pubspec.yaml

To be continued...<br>

configurations in your project pubspec.yaml<br>

    dependencies:
    sresources_generator: x.x.x

    // optional configurations
    sresources:
        output: lib/resources/ #output folder
        
        colors:
            enabled: true #enable generator
            path: assets/color/ #color xml file folder path
            default: 0 #color xml file for default theme, note that each color xml should named with the theme value
            name: AppColors #class name
    
        images:
            enabled: true #enable generator
            path: assets/images/ #image file folder(parent) path
            default: 0 #image file folder for default theme, note that each folder should named with the theme value
            name: AppImagess #class name

        //haven't implement this
        languages:
            enabled: true #enable generator
            source: /lib/language_folder/en.dart #language text file, optional, can use AppTextsSource annotation see example
            name: AppTexts #class name
            
        languages_get: #GetX library style
            enabled: true #enable generator(opposite with languages config)
            source: /lib/language_folder/en.dart #language text file, optional, can use AppTextsSource annotation see example
         name: AppTexts #class name

        //in writing...
        routes_get: #GetX library style page route
            enabled: true #enable generator
            name: AppRoutes #class name
            


    flutter:
        assets:
          - assets/images/
          - assets/images/0/  #themes 0 images folder
          - assets/images/1/  #themes 1 images folder

    exclude:
        - assets/color/  #exclude the color resources xml files(don't add to build packages)