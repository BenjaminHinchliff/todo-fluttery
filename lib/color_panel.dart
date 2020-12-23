import 'package:flutter/material.dart';

class ColorPanel extends StatelessWidget {
  ColorPanel({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 25,
      width: 25,
    );
  }
}
