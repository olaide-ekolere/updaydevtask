import 'package:flutter/material.dart';
import 'package:upday_dev_task/localization/app_translations.dart';

class SearchErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error,
              size: 32.0,
            ),
            Text(
              AppTranslations.of(context).text('error_text'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body2,
            )
          ],
        ),
      ),
    );
  }
}
