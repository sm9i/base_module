import 'package:base_module/base_module.dart';
import 'package:flutter/cupertino.dart';

class DefaultController<T> extends BaseControl<T> {
  //处理全局error
  void onError(Error error) {
    debugPrint('error $error');
    setError();
  }
}
