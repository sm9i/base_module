import 'package:base_module_example/refresh/refresh_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'test_page.dart';

final List<GetPage> getPages = <GetPage>[
  _buildGetPage<TestController>('/test', TestPage(), TestController()),
  _buildGetPage('/refresh', RefreshPage(), null)
];

GetPage _buildGetPage<C>(String name, Widget child, C controller) {
  return GetPage(
    name: name,
    page: () => child,
    binding: controller != null
        ? BindingsBuilder<C>(() => Get.lazyPut<C>(() => controller))
        : null,
  );
}
