import 'dart:ui';

class Application {

  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  final Map<String, String> supportedLanguages = {
    "en": "English",
    "es": "Spanish",
  };


  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguages.keys.map<Locale>((key) => Locale(key, supportedLanguages[key]));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);