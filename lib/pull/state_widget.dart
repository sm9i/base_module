import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuple/tuple.dart';

typedef StateBuilder<M> = Widget Function(BuildContext context, M m);

class MultiStateWidget<P extends SingleProvider<M>, M> extends StatelessWidget {
  const MultiStateWidget({
    Key key,
    @required this.provider,
    @required this.builder,
  }) : super(key: key);
  final P provider;
  final StateBuilder<M> builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<P>(
      create: (_) => provider,
      child: Selector<P, Tuple3<PageState, M, String>>(
        builder:
            (BuildContext context, Tuple3<PageState, M, String> value, __) {
          final PageState pageState = value.item1;
          Widget resWidget;
          if (pageState == PageState.LOADING) {
            resWidget = b('loading');
          }
          if (pageState == PageState.ERROR) {
            resWidget = b(value?.item3 ?? 'error');
          }
          if (pageState == PageState.EMPTY) {
            resWidget = b(value?.item3 ?? 'empty');
          }
          if (pageState == PageState.LOGIN) {
            resWidget = b(value?.item3 ?? 'no login');
          }
          resWidget = builder(context, value.item2);
          return SmartRefresher(
            controller: provider.refreshController,
            onRefresh: provider.isRefresh ? provider.onRefresh : null,
            onLoading: provider.isLoadMore ? provider.onLoadMore : null,
            header: provider.headerWidget,
            footer: provider.footWidget,
            child: resWidget,
          );
        },
        selector: (_, P provider) => Tuple3<PageState, M, String>(
            provider.pageState, provider.m, provider.msg),
      ),
    );
  }

  Widget b(String s) {
    return Text(s);
  }
}

abstract class SingleProvider<M> extends ChangeNotifier {
  final RefreshController _refreshController = RefreshController();

  String _msg;
  PageState _pageState = PageState.LOADING;
  M _m;

  void onRefresh() {}

  void onLoadMore() {}

  ///empty
  void setEmpty({String msg}) {
    if (_pageState == PageState.EMPTY) {
      return;
    }
    _pageState = PageState.EMPTY;
    _msg = _msg;
    notifyListeners();
  }

  ///error
  void setError({String msg}) {
    if (_pageState == PageState.ERROR) {
      return;
    }
    _pageState = PageState.ERROR;
    _msg = _msg;
    notifyListeners();
  }

  void setNoLogin() {
    if (_pageState == PageState.LOGIN) {
      return;
    }
    _pageState = PageState.LOGIN;
    _msg = _msg;
    notifyListeners();
  }

  void setLoading() {
    if (_pageState == PageState.LOADING) {
      return;
    }
    _pageState = PageState.LOADING;
    _msg = _msg;
    notifyListeners();
  }

  void setContent(M m) {
    _m = m;
    _pageState = PageState.CONTENT;
    notifyListeners();
  }

  void resetRefreshController({bool noData = false}) {
    if (noData) {
      refreshController.loadNoData();
    } else {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  M get m => _m;

  String get msg => _msg;

  PageState get pageState => _pageState;

  RefreshController get refreshController => _refreshController;

  bool get isLoadMore => true;

  bool get isRefresh => true;

  Widget get headerWidget => const ClassicHeader();

  Widget get footWidget => const ClassicFooter();
}

enum PageState {
  EMPTY,
  LOADING,
  CONTENT,
  LOGIN,
  ERROR,
}

Widget configRefresh(Widget child) {
  return RefreshConfiguration(
    child: child,
  );
}
