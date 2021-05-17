import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

import 'example1/page.dart';

final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
  GetPage<dynamic>(
    name: 'example1',
    page: () => Example1Page(),
    binding: BindingsBuilder<void>(
      () => Get.lazyPut(() => Page1Controller()),
    ),
  ),
];
