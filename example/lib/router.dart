import 'package:example/pages/page1.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> getPages = <GetPage<dynamic>>[
  GetPage<dynamic>(
    name: '/page1',
    page: () => Page1(),
    binding: BindingsBuilder<void>(() => Get.lazyPut(() => Page1Controller())),
  ),
];
