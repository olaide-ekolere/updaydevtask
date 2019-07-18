import 'package:flutter/material.dart';
import 'package:upday_dev_task/widgets/image_search_phrase/search_button_base.dart';

class EnabledSearchButton extends SearchButtonBase {
  EnabledSearchButton({
    Color buttonColor,
    Color iconColor,
    Key key,
    VoidCallback onPressed,
  }) : super(
          onPressed: onPressed,
          buttonColor: buttonColor,
          iconColor: iconColor,
          key: key,
        );
}
