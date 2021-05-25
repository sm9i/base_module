import 'dart:async';

import 'package:base_module/base_module.dart';

class BaseController<T> extends StateController<T> {
  ///onerror
  ///
  ///
  // ignore: prefer_void_to_null
  Future<Null> onError(dynamic error) {

    loadFailed();
    setError();
    return null;
  }
}
