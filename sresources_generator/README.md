A generator for colors,images,language texts etc.
Can adjust to GetX library.
Learnt from flutter_gen.


configurations in pubspec.yaml

dependencies:
    sresources_generator: x.x.x

#optional configurations
sresources:
    output: lib/resources/ #output folder
        
    colors:
        enabled: true #enable generator
        path: assets/color/ #color xml file folder path
        default: 0 #color xml file for default theme, note that each color xml should named with the theme value
        name: AppColors #class name
    
    images:
        enabled: true #enable generator
        path: assets/image/ #image file folder(parent) path
        default: 0 #image file folder for default theme, note that each folder should named with the theme value
        name: AppImagess #class name

    languages:
        enabled: true #enable generator
        source: /lib/language_folder/en.dart #language text file,
        name: AppTexts #class name
            
    languages_get: #GetX library style
        enabled: true #enable generator(opposite with languages config)
        source: /lib/language_folder/en.dart #language text file,
        name: AppTexts #class name

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