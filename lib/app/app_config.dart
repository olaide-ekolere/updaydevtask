import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String clientId;
  final String clientSecret;

  AppConfig({
    this.clientId,
    this.clientSecret,
    Widget child,
  }) : super(child: child);

  static AppConfig of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppConfig);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
