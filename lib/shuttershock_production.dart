import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upday_dev_task/app/app.dart';
import 'package:upday_dev_task/app/app_config.dart';

void main() async {
  var preferences = await SharedPreferences.getInstance();
  var client = http.Client();
  var configuredApp = AppConfig(
    clientId: 'add77-553d2-738cf-3f733-ca562-04ad4',
    clientSecret: 'd175a-494aa-b2c93-d7f0c-4f512-0d8f1',
    child: UpdayTaskApp(preferences, client),
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(configuredApp));
  //runApp(UpdayTaskApp(preferences, client));
}

