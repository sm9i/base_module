
import 'package:base_module/utils/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key key, this.msg}) : super(key: key);
  final String msg;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(msg),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key key, this.msg}) : super(key: key);
  final String msg;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(msg),
    );
  }
}

class LoadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
    return Container(
      constraints: BoxConstraints(
        minHeight: Screens.height / 2,
        minWidth: Screens.width,
        maxHeight: Screens.height,
      ),
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
