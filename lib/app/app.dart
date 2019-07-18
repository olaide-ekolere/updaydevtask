import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upday_dev_task/app/app_config.dart';
import 'package:upday_dev_task/colors.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:upday_dev_task/localization/application.dart';
import 'package:upday_dev_task/splash_screen.dart';
import 'package:http/http.dart' as http;

bool useMobileLayout;

ThemeData _buildTheme() {
  ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kAccent900,
    primaryColor: kPrimary100,
    buttonColor: kPrimary100,
    scaffoldBackgroundColor: kBackgroundWhite,
    cardColor: kBackgroundWhite,
    textSelectionColor: Colors.white,
    errorColor: kErrorRed,
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    primaryIconTheme: base.primaryIconTheme.copyWith(
      color: kAccent900,
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

class UpdayTaskApp extends StatefulWidget {
  final SharedPreferences preferences;
  final http.Client client;
  UpdayTaskApp(this.preferences, this.client);
  createState() => _UpdayTaskAppState();
}
class _UpdayTaskAppState extends State<UpdayTaskApp>{
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: application.supportedLocales().first);
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
    var config = AppConfig.of(context);
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
      home: SplashPage(widget.preferences, widget.client),
      navigatorObservers: [routeObserver],
    );
  }
}
