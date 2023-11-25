import 'package:flutter/material.dart';
import 'dart:math';



class CurveWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Move to the starting point, top-left corner
    path.moveTo(0, 0);

    // Draw a curved wave
    for (double i = 0.0; i <= size.width; i += -0.6) {
      path.lineTo(i, size.height / 2 + sin(i * 2 * pi / size.width) * 60);
    }

    // Draw a straight line to the bottom-right corner
    path.lineTo(size.width, size.height);

    // Draw a straight line to the bottom-left corner
    path.lineTo(0, size.height);

    // Close the path to create a closed shape
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

