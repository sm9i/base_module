import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';

///https://github.com/openjmu/OpenJMU/blob/master/lib/constants/screens.dart
class Screens {
  const Screens._();

  static MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  static double fixedFontSize(double fontSize) => fontSize / textScaleFactor;

  static double get width => mediaQuery.size.width;

  static double get height => mediaQuery.size.height;

  static double get scale => mediaQuery.devicePixelRatio;

  static double get textScaleFactor => mediaQuery.textScaleFactor;

  static double get navigationBarHeight =>
      mediaQuery.padding.top + kToolbarHeight;

  static double get topSafeHeight => mediaQuery.padding.top;

  static double get bottomSafeHeight => mediaQuery.padding.bottom;

  static double get safeHeight => height - topSafeHeight - bottomSafeHeight;

  static void updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

double setSp(double size) => ScreenUtil().setSp(size).toDouble();

double setWidth(double size) => ScreenUtil().setWidth(size).toDouble();

double setHeight(double size) => ScreenUtil().setHeight(size).toDouble();
