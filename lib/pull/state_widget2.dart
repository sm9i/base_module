import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final Widget? error;

  final Widget? empty;

  final Widget? loading;

  Widget emptyWidget() {
    return Container();
  }

  Widget errorWidget() {
    return Container();
  }

  Widget loadingWidget() {
    return loadingWidget();
  }

  Widget contentWidget() {
    return Expanded(child: Obx(() {
      if (controller.state.value == _State.CONTENT) {
        return Container();
      } else if (controller.state.value == _State.ERROR) {
        return errorWidget();
      } else if (controller.state.value == _State.EMPTY) {
        return emptyWidget();
      } else if (controller.state.value == _State.LOADING) {
        return loadingWidget();
      } else {
        return const SizedBox();
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (headerBuilder != null)
          Obx(() => headerBuilder!(context, controller.content.value)),
        contentWidget(),
        if (footerBuilder != null)
          Obx(() => footerBuilder!(context, controller.content.value)),
      ],
    );
  }
}

class StateController<T> extends GetxController {
  ///页面状态
  Rx<_State> state = Rx<_State>(_State.LOADING);

  ///主要数据
  Rx<T?> content = Rx<T?>(null);

  @override
  void onInit() {
    _log('onInit');
    super.onInit();
  }

  @override
  void onClose() {
    _log('onClose');
    super.onClose();
  }

  @override
  void onReady() {
    _log('onReady');
    super.onReady();
  }

  void _log(String log) {
    Get.log('PageController = $log');
  }
}

///页面重的状态
enum _State {
  CONTENT,
  LOADING,
  EMPTY,
  ERROR,
  CUSTOM,
}
