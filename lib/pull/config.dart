import 'package:flutter/material.dart';

class ConfigState extends InheritedWidget {
  const ConfigState({
    @required this.child,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.noLoginWidget,
  });

  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget emptyWidget;
  final Widget noLoginWidget;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ConfigState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigState>();
  }
}
