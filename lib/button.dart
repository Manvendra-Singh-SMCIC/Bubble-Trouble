import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final icons;
  final function;

  const Button({this.icons, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      onLongPress: function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 50,
          height: 50,
          color: Colors.grey[50],
          child: Center(
            child: Icon(icons),
          ),
        ),
      ),
    );
  }
}
