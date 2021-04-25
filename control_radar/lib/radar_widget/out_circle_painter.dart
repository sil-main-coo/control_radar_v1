import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class OutCirclePainter extends CustomPainter {
  final double radius;

  Paint _fillerLinePaint = Paint()
    ..color = Colors.black26
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  int circleCount;

  OutCirclePainter(
    this.radius, {
    this.circleCount = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final lenght = 2 * radius;

//    // draw vertical line
    canvas.drawLine(Offset(size.width / 2, size.height / 2 - radius),
        Offset(size.width / 2, size.height / 2 - lenght), _fillerLinePaint);
    canvas.drawLine(Offset(size.width / 2, size.height / 2 + radius),
        Offset(size.width / 2, size.height / 2 + lenght), _fillerLinePaint);

    // draw horizontal line
    canvas.drawLine(Offset(size.width / 2 - radius, size.height / 2),
        Offset(size.width / 2 - lenght, size.height / 2), _fillerLinePaint);
    canvas.drawLine(Offset(size.width / 2 + radius, size.height / 2),
        Offset(size.width / 2 + lenght, size.height / 2), _fillerLinePaint);

    // radius = (maxRadius * i) / circleCount
    for (var i = 7; i <= circleCount; ++i) {
      canvas.drawCircle(center, radius * i / 6, _fillerLinePaint);
    }

//    canvas.save();
    // rotate the canvas

    rotate(canvas, size.width / 2, size.height / 2, pi / 6);
    canvas.drawLine(Offset(size.width / 2, size.height / 2 - lenght),
        Offset(size.width / 2, size.height / 2 + lenght), _fillerLinePaint);
    rotate(canvas, size.width / 2, size.height / 2, pi / 6);
    canvas.drawLine(Offset(size.width / 2, size.height / 2 - lenght),
        Offset(size.width / 2, size.height / 2 + lenght), _fillerLinePaint);

    rotate(canvas, size.width / 2, size.height / 2, pi / 3);
    canvas.drawLine(Offset(size.width / 2, size.height / 2 - lenght),
        Offset(size.width / 2, size.height / 2 + lenght), _fillerLinePaint);
    rotate(canvas, size.width / 2, size.height / 2, pi / 6);
    canvas.drawLine(Offset(size.width / 2, size.height / 2 - lenght),
        Offset(size.width / 2, size.height / 2 + lenght), _fillerLinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // vẽ lại
    return true;
  }

  void rotate(Canvas canvas, double cx, double cy, double angle) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }
}
