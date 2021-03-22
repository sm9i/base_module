import 'package:base_module_example/refresh/refresh_widget.dart';
import 'package:flutter/material.dart';

class RefreshPage extends StatefulWidget {
  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('refresh test'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: RefreshWidget()),
          Expanded(
            child: Container(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
