import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PointRadarPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  PointRadarPainter(this.points, {this.color = Colors.red});

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.points;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
