import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

///随机颜色
Color _randomColor = Color.fromARGB(
    255, randomInt(max: 255), randomInt(max: 255), randomInt(max: 255));

///随机int
int randomInt({int max = 100}) => math.Random().nextInt(max);

///随机double
double randomDouble() => math.Random().nextDouble();

///getter
Color get randomColor => _randomColor;
