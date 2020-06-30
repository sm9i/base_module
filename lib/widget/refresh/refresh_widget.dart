import 'package:base_module/widget/refresh/refresh_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';

///
/// 下拉刷新widget
class RefreshWidget extends StatelessWidget {
  const RefreshWidget({
    Key key,
    @required this.refreshController,
    @required this.child,
    this.onRefresh,
    this.onLoad,
  }) : super(key: key);

  ///controller
  final RefreshController refreshController;
  final Widget child;
  final OnRefreshCallback onRefresh;
  final OnLoadCallback onLoad;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller:
          refreshController?.easyRefreshController ?? EasyRefreshController(),
      child: child,
      onLoad: onLoad,
      onRefresh: onRefresh,
      header: MaterialHeader(),
    );
  }
}
