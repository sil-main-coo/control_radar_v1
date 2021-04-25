import 'package:controlradar/radar_widget/radar_painter.dart';
import 'package:flutter/material.dart';

class RadarView extends StatelessWidget {
  final double angle;
  final double radius;

  RadarView({this.angle, this.radius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadarPainter(angle, radius),
    );
  }
}
