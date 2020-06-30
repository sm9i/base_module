import 'package:flutter_easyrefresh/easy_refresh.dart';

class RefreshController {
  RefreshController() : _easyRefreshController = EasyRefreshController();

  final EasyRefreshController _easyRefreshController;

  void onRefreshComplete({bool success = true}) {
    _easyRefreshController.finishRefresh(success: success);
  }

  void onLoadMoreComplete({bool success = true}) {
    _easyRefreshController.finishLoad(success: success);
  }

  void onLoadMoreNoData() {
    _easyRefreshController.finishLoad(success: true, noMore: true);
  }

  void refresh() {
    _easyRefreshController.callRefresh();
  }

  void dispose() {
    _easyRefreshController.dispose();
  }

  EasyRefreshController get easyRefreshController => _easyRefreshController;
}
