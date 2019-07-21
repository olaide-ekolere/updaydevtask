import 'package:flutter/material.dart';
import 'package:upday_dev_task/localization/app_translations.dart';

class NoSearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.history,
              size: 32.0,
            ),
            Text(
              AppTranslations.of(context).text('no_search_init'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body2,
            )
          ],
        ),
      ),
    );
  }
}
