import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color colour;
  final String title;
  final VoidCallback onPressed;
  final Function(bool)? onHover; // Define the onHover parameter

  RoundedButton({
    required this.colour,
    required this.title,
    required this.onPressed,
    this.onHover, // Accept onHover as an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover?.call(true), // Call onHover when entering
      onExit: (_) => onHover?.call(false), // Call onHover when exiting
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
