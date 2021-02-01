import 'package:flutter/material.dart';

class ConfigState extends InheritedWidget {
  const ConfigState({
    Key key,
    @required Widget child,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.noLoginWidget,
  }) : super(key: key, child: child);

  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget emptyWidget;
  final Widget noLoginWidget;

  @override
  bool updateShouldNotify(covariant ConfigState oldWidget) {
    return oldWidget.loadingWidget != loadingWidget ||
        oldWidget.errorWidget != errorWidget ||
        oldWidget.emptyWidget != emptyWidget ||
        oldWidget.noLoginWidget != noLoginWidget;
  }

  static ConfigState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigState>();
  }
}
