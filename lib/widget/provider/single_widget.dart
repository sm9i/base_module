import 'package:base_module/widget/refresh/refresh_controller.dart';
import 'package:base_module/widget/refresh/refresh_widget.dart';
import 'package:base_module/widget/states/multi_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'single_provider.dart';

typedef SingleBuilder<T> = Widget Function(BuildContext context, T value);

class SingleWidget<P extends _SingleProvider<T>, T> extends StatelessWidget {
  const SingleWidget({
    Key key,
    this.provider,
    this.builder,
  }) : super(key: key);
  final P provider;
  final SingleBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return MultiWidget(
      provider: provider.widgetProvider,
      content: RefreshWidget(
        refreshController: provider.refreshController,
        onRefresh: provider.onRefresh,
        onLoad: provider.onLoad,
        child: ChangeNotifierProvider<P>(
          create: (_) => provider,
          child: Selector<P, T>(
            builder: (BuildContext context, T value, __) =>
                builder(context, value),
            selector: (_, P p) => p.info,
          ),
        ),
      ),
    );
  }
}

abstract class SingleProvider<T> extends _SingleProvider<T> {
  SingleProvider() {
    getInfo().then((T value) {
      _info = value;
      onInfoSuccess();
    }).then((dynamic e) {
      onInfoError();
    });
  }
}

class A extends SingleProvider<String> {
  @override
  Future<String> getInfo() {
    return Future<String>.delayed(const Duration(seconds: 2), () => '呜呜呜');
  }
}
