import 'package:flutter/material.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';

class AppConfig extends InheritedWidget {
  final ImageSearchDataProvider imageSearchDataProvider;
  final int pageCount;

  AppConfig({
    this.imageSearchDataProvider,
    this.pageCount,
    Widget child,
  })  : assert(imageSearchDataProvider != null),
        assert(pageCount != null),
        assert(child != null),
        super(child: child);

  static AppConfig of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppConfig);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
