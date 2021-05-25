import 'package:base_module/base_module.dart';
import 'package:example/common.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: MultiStateWidget<String, Page1Controller>(
        builder: (BuildContext context, String value) {
          return Center(
            child: Text(value ?? ''),
          );
        },
      ),
    );
  }
}

class Page1Controller extends BaseController<String> {
  @override
  void getInfo([bool changeLoading]) {
    super.getInfo(changeLoading);
    Future<String>.delayed(const Duration(milliseconds: 3000), () {
      return 'come on ';
    }).then((String value) {
      throw '1';
      setContent(value);
    }).catchError(onError);
  }
}
