import 'package:base_module/base_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef StateBuilder<M> = Widget Function(BuildContext context, M m);

class MultiStateWidget<C extends BaseControl<M>, M> extends GetView<C> {
  const MultiStateWidget({
    Key key,
    @required this.builder,
    this.headerBuilder,
    this.footerBuilder,
    this.empty,
    this.error,
    this.loading,
  }) : super(key: key);

  ///布局builder
  final StateBuilder<M> builder;
  final StateBuilder<M> headerBuilder;
  final StateBuilder<M> footerBuilder;

  final Widget empty;
  final Widget error;
  final Widget loading;

  Widget errorWidget(BuildContext context) =>
      error ??
      ConfigState?.of(context)?.errorWidget ??
      Center(child: Text('加载出错', style: Theme.of(context).textTheme.bodyText2));

  Widget loadingWidget(BuildContext context) =>
      loading ??
      ConfigState?.of(context)?.loadingWidget ??
      const Center(child: CupertinoActivityIndicator());

  Widget emptyWidget(BuildContext context) =>
      empty ??
      ConfigState?.of(context)?.errorWidget ??
      Center(child: Text('暂无数据', style: Theme.of(context).textTheme.bodyText2));

  Widget footerWidget(BuildContext context) =>
      ConfigState?.of(context)?.footerWidget ?? const SizedBox();

  Widget headerWidget(BuildContext context) =>
      ConfigState?.of(context)?.headerWidget ?? const SizedBox();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (headerBuilder != null)
          Obx(() => headerBuilder.call(context, controller.m.value)),
        Expanded(
          child: Obx(() {
            Widget currentWidget;
            if (controller.pageState.value == PageState.CONTENT) {
              currentWidget = Obx(() => builder(context, controller.m.value));
            } else if (controller.pageState.value == PageState.EMPTY) {
              currentWidget = emptyWidget(context);
            } else if (controller.pageState.value == PageState.ERROR) {
              currentWidget = errorWidget(context);
            } else {
              currentWidget = loadingWidget(context);
            }
            return currentWidget;
            // return SmartRefresher(
            //   controller: controller.refreshController,
            //   scrollController: controller.scrollController,
            //   onRefresh: controller.isRefresh ? controller.onRefresh : null,
            //   onLoading: controller.isLoadMore ? controller.onLoadMore : null,
            //   enablePullDown: controller.isRefresh,
            //   enablePullUp: controller.isLoadMore &&
            //       controller.pageState.value == PageState.CONTENT,
            //   child: currentWidget,
            // );
          }),
        ),
        if (footerBuilder != null)
          Obx(() => headerBuilder.call(context, controller.m.value)),
      ],
    );
  }
}

class BaseControl<M> extends GetxController {
  // final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  final Rx<PageState> _pageState = Rx<PageState>(PageState.LOADING);

  Rx<M> _m;

  /// 加载数据
  @mustCallSuper
  void getInfo([bool checkLoading = false]) {
    if (checkLoading) {
      setLoading();
    }
  }

  @override
  void onReady() {
    super.onReady();
    getInfo(true);
  }

  @override
  void onClose() {
    // _refreshController.dispose();
    _scrollController.dispose();
    Get.log('close');
    super.onClose();
  }

  void onRefresh() => getInfo();

  void onLoadMore() => getInfo();

  void setContent(M m, {bool checkList = true}) {
    if (m is List && m.length == 0 && checkList) {
      _pageState.value = PageState.EMPTY;
    } else {
      if (_m == null) {
        _m = Rx<M>(m);
      } else {
        _m.value = m;
      }
      _pageState.value = PageState.CONTENT;
    }
  }

  void setLoading() {
    if (_pageState.value == PageState.LOADING) {
      return;
    }
    _pageState.value = PageState.LOADING;
    print(_pageState);
  }

  void setEmpty() {
    if (_pageState.value == PageState.EMPTY) {
      return;
    }
    _pageState.value = PageState.EMPTY;
  }

  void setError() {
    if (_pageState.value == PageState.ERROR) {
      return;
    }
    _pageState.value = PageState.ERROR;
  }

  bool get isLoadMore => false;

  bool get isRefresh => false;

  Rx<M> get m => _m;

  Rx<PageState> get pageState => _pageState;

  ScrollController get scrollController => _scrollController;

  // RefreshController get refreshController => _refreshController;

  ControllerParam get param => null;
}

///加载更多的controller

abstract class LoadMoreControl<M> extends BaseControl<M> {
  @override
  void onLoadMore() {
    param.page += 1;
    getInfo();
  }

  @override
  void onRefresh() {
    param.page = 0;
    super.onRefresh();
  }
}

enum PageState {
  EMPTY,
  LOADING,
  CONTENT,
  LOGIN,
  ERROR,
}

class ControllerParam {
  ControllerParam(this.page, this.size);

  int page;
  int size;
}
