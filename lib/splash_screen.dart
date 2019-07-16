import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:upday_dev_task/localization/app_translations.dart';

import 'colors.dart';

class SplashPage extends StatefulWidget {
  final SharedPreferences preferences;
  final http.Client client;

  SplashPage(this.preferences, this.client);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _requiresReload = false;
  String title;
  bool errorOccurred = false;

  _handleNavigation() async {}

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
    title = AppTranslations.of(context).text('affiliate_text');
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
        color: kBackgroundWhite,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0 / MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                Text(
                  AppTranslations.of(context).text('by_text'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0 / MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                Text(
                  AppTranslations.of(context).text('author'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0 / MediaQuery.of(context).textScaleFactor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
