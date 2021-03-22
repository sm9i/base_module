import 'package:base_module/pull/state_widget.dart';
import 'package:flutter/material.dart';

import 'default_controller.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: MultiStateWidget<TestController, String>(
          builder: (BuildContext context, String value) {
        return Container(
          child: Text(value ?? ''),
        );
      }),
    );
  }
}

class TestController extends DefaultController<String> {
  @override
  void getInfo([bool checkLoading = false]) {
    super.getInfo(checkLoading);
  }
}
