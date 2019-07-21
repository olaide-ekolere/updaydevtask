import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:upday_dev_task/localization/application.dart';
import 'package:upday_dev_task/model/image_search.dart';
import 'package:upday_dev_task/page/image_search_page.dart';

import 'colors.dart';

class SplashPage extends StatefulWidget {
  final ImageSearch imageSearch;

  SplashPage(this.imageSearch,);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _requiresReload = false;
  String title;
  bool errorOccurred = false;

  _handleNavigation() async {
    Locale myLocale = Localizations.localeOf(context);
    print('Language Code: ${myLocale.languageCode}');
    if(application.supportedLanguages.containsKey(myLocale.languageCode)) {
      application.onLocaleChanged(myLocale);
    }
    //Locale locale = ui.window.locale;
    //print('Language Code: ${locale.languageCode}');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => _launchImageSearchPage()));
  }

  Widget _launchImageSearchPage() {
    return BlocProvider(
      child: ImageSearchPage(),
      bloc: ImageSearchBloc(widget.imageSearch),
    );
  }

  _startTimeout() async {
    var duration = Duration(
      seconds: 2,
    );

    return Timer(
      duration,
      _handleNavigation,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startTimeout();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8.0,
                ),
                Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width / 3.0,
                ),
                Text(
                  AppTranslations.of(context).text('app_name'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body2,
                ),
                Text(
                  AppTranslations.of(context).text('by_text'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body2,
                ),
                Text(
                  AppTranslations.of(context).text('author'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
