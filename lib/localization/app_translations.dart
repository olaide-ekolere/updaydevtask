
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:upday_dev_task/localization/application.dart';

class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  AppTranslations(Locale locale) {
    this.locale = locale;
    _localisedValues = null;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale, String testValues) async {
    AppTranslations appTranslations = AppTranslations(locale);
    String url = "assets/locale/localization_${locale.languageCode}.json";
    String jsonContent =
        testValues?? await rootBundle.loadString("assets/locale/localization_${locale.languageCode}.json");
    //print(jsonContent);
    //print('Before ${locale.languageCode}');
    _localisedValues = json.decode(jsonContent);
    //print('After');
    if(_localisedValues==null)print('Its null');
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues==null? '' : (_localisedValues[key] ?? "$key not found");
  }

  List<String> textArray(String key) {
    if(_localisedValues==null) return ['','','','','','','','','','','',''];
    else return _localisedValues[key]!=null? List.from(_localisedValues[key]) : [];
  }
}

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  final Locale newLocale;
  final String testValues;
  const AppTranslationsDelegate({this.newLocale, this.testValues});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguages.keys.contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) {
    return AppTranslations.load(newLocale ?? locale, testValues);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }
}