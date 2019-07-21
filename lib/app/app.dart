import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upday_dev_task/app/app_config.dart';
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/colors.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:upday_dev_task/localization/application.dart';
import 'package:upday_dev_task/model/image_search.dart';
import 'package:upday_dev_task/splash_screen.dart';
import 'package:http/http.dart' as http;

bool useMobileLayout;

ThemeData _buildTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    accentColor: Colors.purple,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
      body2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)
    ),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(
          fontSize: 18.0,
        ),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        displayColor: kPrimary400,
        bodyColor: kPrimary400,
      );
}

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
AppConfig appConfig;

class UpdayTaskApp extends StatefulWidget {
  final SharedPreferences preferences;
  final http.Client client;

  UpdayTaskApp(this.preferences, this.client);

  createState() => _UpdayTaskAppState();
}

class _UpdayTaskAppState extends State<UpdayTaskApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(
        newLocale: application.supportedLocales().first);
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    appConfig = AppConfig.of(context);
    final imageSearchPhraseBloc = ImageSearchPhraseBloc(
      appConfig.imageSearchDataProvider,
      appConfig.pageCount,
      //initiateSearchObserver,
    );
    final imageSearchResultBloc = ImageSearchResultBloc(
      appConfig.imageSearchDataProvider,
      appConfig.pageCount,
    );
    final imageSearch = ImageSearch(
      imageSearchPhraseBloc: imageSearchPhraseBloc,
      imageSearchResultBloc: imageSearchResultBloc,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        _newLocaleDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: application.supportedLocales(),
      theme: _buildTheme(),
      title: '',
      //theme: _buildTheme(),
      home: SplashPage(imageSearch),
      navigatorObservers: [routeObserver],
    );
  }
}
