import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  final double angle; // góc
  final double radius;

  // paint of lines
  Paint _bgPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  Paint _fillerLinePaint = Paint()
    ..color = Colors.black26
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  // paint of line scan
  Paint _paint = Paint()..style = PaintingStyle.fill;

  int circleCount;

  RadarPainter(
    this.angle, this.radius,{
    this.circleCount = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // draw vertical line
    canvas.drawLine(Offset(size.width / 2, size.height / 2 - radius),
        Offset(size.width / 2, size.height / 2 + radius), _bgPaint);

    // draw horizontal line
    canvas.drawLine(Offset(size.width / 2 - radius, size.height / 2),
        Offset(size.width / 2 + radius, size.height / 2), _bgPaint);

    // draw circle line
    // radius = (maxRadius * i) / circleCount
    for (var i = 1; i <= circleCount; ++i) {
      canvas.drawCircle(center, radius * i / circleCount, _bgPaint);
    }

    canvas.save();
    // rotate the canvas
    rotate(canvas, size.width / 2, size.height / 2, pi/6);
    canvas.drawLine(
        Offset(size.width / 2, size.height / 2 - radius),
        Offset(size.width / 2, size.height / 2 + radius),
        _fillerLinePaint);
    rotate(canvas, size.width / 2, size.height / 2, pi/6);
    canvas.drawLine(
        Offset(size.width / 2, size.height / 2 - radius),
        Offset(size.width / 2, size.height / 2 + radius),
        _fillerLinePaint);

    rotate(canvas, size.width / 2, size.height / 2, pi/3);
    canvas.drawLine(
        Offset(size.width / 2, size.height / 2 - radius),
        Offset(size.width / 2, size.height / 2 + radius),
        _fillerLinePaint);
    rotate(canvas, size.width / 2, size.height / 2, pi/6);
    canvas.drawLine(
        Offset(size.width / 2, size.height / 2 - radius),
        Offset(size.width / 2, size.height / 2 + radius),
        _fillerLinePaint);
    canvas.restore();

    // set đổ bóng cho đường quay
    _paint.shader = ui.Gradient.sweep(
        Offset(size.width / 2, size.height / 2),
        [Colors.green.withOpacity(.01), Colors.green.withOpacity(.5)],
        [.0, 1.0],
        TileMode.repeated,
        .0,
        pi / 8);

    canvas.save();

    // set quay tròn
    double r = sqrt(pow(size.width, 2) + pow(size.height, 2));
    double startAngle = atan(size.height / size.width);
    Point p0 = Point(r * cos(startAngle), r * sin(startAngle));
    Point px = Point(r * cos(angle + startAngle), r * sin(angle + startAngle));
    canvas.translate((p0.x - px.x) / 2, (p0.y - px.y) / 2);
    canvas.rotate(angle);

    // vẽ đường quay
    canvas.drawArc(
        Rect.fromCircle(
            center: center, radius: radius),
        0,
        -pi / 8,
        true,
        _paint);
    canvas.restore();
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
