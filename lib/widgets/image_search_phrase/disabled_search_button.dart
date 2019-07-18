import 'package:flutter/material.dart';
import 'package:upday_dev_task/widgets/image_search_phrase/search_button_base.dart';


class DisabledSearchButton extends SearchButtonBase {
  DisabledSearchButton({
    Color buttonColor,
    Color iconColor,
    Key key,
  }) : super(
          onPressed: (){},
          buttonColor: buttonColor,
          iconColor: iconColor,
          key: key,
        );
}
