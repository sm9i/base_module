import 'package:base_module/pull/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///content builder
typedef StateBuilder<M> = Widget Function(BuildContext context, M m);

class MultiStateWidget<M, C extends StateController<M>> extends GetView<C> {
  ///
  const MultiStateWidget({
    Key? key,
    required this.builder,
    this.headerBuilder,
    this.footerBuilder,
    this.error,
    this.empty,
    this.loading,
  }) : super(key: key);

  final StateBuilder<M?> builder;

  final StateBuilder<M?>? headerBuilder;

  final StateBuilder<M?>? footerBuilder;

  final StateBuilder<M?>? error;

  final StateBuilder<M?>? empty;

  final Widget? loading;

  Widget emptyWidget() {
    if (empty != null) {
      return Builder(builder: (BuildContext context) => empty!(context, controller._content.value));
    } else {
      return StateEmptyWidget();
    }
  }

  Widget errorWidget() {
    if (error != null) {
      return Builder(builder: (BuildContext context) => error!(context, controller._content.value));
    } else {
      return StateErrorWidget();
    }
  }

  Widget loadingWidget() {
    if (loading != null) {
      return loading!;
    } else {
      return StateLoadingWidget();
    }
  }

  Widget contentWidget() {
    return Builder(builder: (BuildContext context) {
      return Expanded(child: Obx(() {
        if (controller._state.value == _State.CONTENT) {
          return SmartRefresher(
            scrollController: controller.scrollController,
            controller: controller.refreshController,

            child: builder(context, controller._content.value),

            ///是否可以加载更多
            ///设置 并且当前页面状态是content
            enablePullUp: controller.canLoadMore() && controller._state.value == _State.CONTENT,

            ///是否可以刷新
            enablePullDown: controller.canRefresh(),

            ///下拉
            onRefresh: controller.canRefresh() ? controller._onRefresh : null,

            ///上拉
            onLoading: controller.canLoadMore() ? controller._onLoadMore : null,
          );
        } else if (controller._state.value == _State.ERROR) {
          return Center(child: errorWidget());
        } else if (controller._state.value == _State.EMPTY) {
          return Center(child: emptyWidget());
        } else if (controller._state.value == _State.LOADING) {
          return Center(child: loadingWidget());
        } else {
          return const SizedBox();
        }
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (headerBuilder != null) Obx(() => headerBuilder!(context, controller._content.value)),
        contentWidget(),
        if (footerBuilder != null) Obx(() => footerBuilder!(context, controller._content.value)),
      ],
    );
  }
}

abstract class StateController<T> extends GetxController {
  StateController({this.page = 1, this.size = 15});

  int page, size;

  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  ///页面状态
  final Rx<_State> _state = Rx<_State>(_State.LOADING);

  ///主要数据
  final Rx<T?> _content = Rx<T?>(null);

  ///是否可以下拉刷新
  bool canRefresh() => true;

  ///是否开启加载更多
  bool canLoadMore() => true;

  @mustCallSuper
  void getInfo([bool? changeLoading]) {
    if (changeLoading != null && changeLoading) {
      setLoading();
    }
  }

  void setEmpty() {
    if (_state.value == _State.EMPTY) {
      return;
    }
    _state.value = _State.EMPTY;
  }

  void setError() {
    if (_state.value == _State.ERROR) {
      return;
    }
    _state.value = _State.ERROR;
  }

  void setLoading() {
    if (_state.value == _State.LOADING) {
      return;
    }
    _state.value = _State.LOADING;
  }

  void setContent(T t, {bool checkList = true}) {
    if (t is List && t.length == 0 && checkList) {
      _state.value = _State.EMPTY;
    } else {
      _content.value = t;
      _state.value = _State.CONTENT;
    }
  }

  void _onRefresh() {
    page = 1;
    getInfo();
  }

  void _onLoadMore() {
    page++;
    getInfo();
  }

  void _log(String log) {
    Get.log('PageController = $log');
  }

  @override
  void onInit() {
    _log('onInit');
    super.onInit();
  }

  @override
  void onClose() {
    _log('onClose');
    _scrollController.dispose();
    _refreshController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    _log('onReady');
    super.onReady();
  }

  RefreshController get refreshController => _refreshController;

  ScrollController get scrollController => _scrollController;

  Rx<_State> get state => _state;

  Rx<T?> get content => _content;
}

///页面重的状态
enum _State {
  CONTENT,
  LOADING,
  EMPTY,
  ERROR,
  // CUSTOM,
}
