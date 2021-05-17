import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Example1Page extends GetView<Page1Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: Center(),
    );
  }
}

class Page1Controller extends GetxController {
  _PageState state = _PageState.CONTENT;

  @override
  void onInit() {
    Get.log('onInit');
    super.onInit();
  }

  @override
  void onClose() {
    Get.log('onClose');
    super.onClose();
  }

  @override
  void onReady() {
    Get.log('onReady');
    super.onReady();
  }
}

enum _PageState { CONTENT, EMPTY, ERROR }
