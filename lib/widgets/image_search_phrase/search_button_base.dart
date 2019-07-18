import 'package:flutter/material.dart';

class SearchButtonBase extends StatelessWidget {
  final VoidCallback _onPressed;
  final Color buttonColor;
  final Color iconColor;

  SearchButtonBase({
    this.buttonColor,
    this.iconColor,
    Key key,
    VoidCallback onPressed,
  })  : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPressed,
      child: Container(
        color: buttonColor,
        padding: EdgeInsets.all(
          8.0,
        ),
        child: Center(
          child: Icon(
            Icons.search,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
