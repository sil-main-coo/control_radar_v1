import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadarConstants {
  static final double topPos = ScreenUtil().screenHeight / 30;
  static final double bottomPos = ScreenUtil().screenHeight / 22;
  static final double leftPos = ScreenUtil().screenWidth / 42;
  static final double rightPos = ScreenUtil().screenWidth / 7.3;

  static final double maxHeightRadius =
      ScreenUtil().screenHeight - (bottomPos + topPos);
  static final double maxWidthRadius =
      ScreenUtil().screenWidth - (leftPos + rightPos);
  static final double radius = min(maxHeightRadius / 2, maxWidthRadius / 2);
}
