import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
  RoundedButton({required this.color, required this.title ,required this.onPrased});
  final Color color;
  final String title;
  final Function() onPrased;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPrased,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}