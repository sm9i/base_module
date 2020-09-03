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
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ConfigState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigState>();
  }
}
