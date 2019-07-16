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
    clientId: 'd0c6b-c141e-00f1e-7067a-f1440-c2ecc',
    clientSecret: '89028-7b04b-07ed8-f051b-01af2-43cf1',
    child: UpdayTaskApp(preferences, client),
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(configuredApp));
  //runApp(UpdayTaskApp(preferences, client));
}

