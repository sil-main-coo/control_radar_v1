import 'package:controlradar/radar_widget/point_painter.dart';
import 'package:controlradar/radar_widget/radar_constants.dart';
import 'package:flutter/material.dart';

class PointsWidget extends StatelessWidget {
  final List<Offset> points;
  final Color color;

  const PointsWidget({Key key, this.points = const [], this.color = Colors.red})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(RadarConstants.maxWidthRadius, RadarConstants.maxHeightRadius),
      painter: PointRadarPainter(points, color: color),
    );
  }
}
