import 'package:base_module/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_module/base_module.dart';

void main() {
  test('adds one to input values', () {
    B().p();
  });
}

class A {
  A() {
    print("AAA");
  }
}

class B extends A {
  void p() {
    print("2");
  }
}
