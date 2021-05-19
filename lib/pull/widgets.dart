import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      '加载失败',
      style: TextStyle(
        fontSize: 16,
        color: Color(0xff999999),
      ),
    );
  }
}

class StateEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      '暂无数据',
      style: TextStyle(
        fontSize: 16,
        color: Color(0xff999999),
      ),
    );
  }
}

class StateLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator();
  }
}
