import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuple/tuple.dart';

typedef StateBuilder<M> = Widget Function(BuildContext context, M m);

class MultiStateWidget<P extends SingleProvider<M>, M> extends StatefulWidget {
  const MultiStateWidget({
    Key key,
    @required this.provider,
    @required this.builder,
    this.empty,
    this.error,
    this.noLogin,
    this.loading,
  }) : super(key: key);

  final P provider;
  final StateBuilder<M> builder;
  final Widget empty;
  final Widget error;
  final Widget noLogin;
  final Widget loading;

  @override
  _MultiStateWidgetState<P, M> createState() => _MultiStateWidgetState<P, M>();
}

class _MultiStateWidgetState<P extends SingleProvider<M>, M>
    extends State<MultiStateWidget<P, M>> {
  @override
  void initState() {
    widget.provider.getInfo();
    super.initState();
  }

  @override
  void dispose() {
    widget.provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget selector = Selector<P, Tuple3<PageState, M, String>>(
      builder: (BuildContext context, Tuple3<PageState, M, String> value, __) {
        final PageState pageState = value.item1;
        Widget resWidget;
        if (pageState == PageState.LOADING) {
          resWidget = Center(
              child: widget.loading ?? const CupertinoActivityIndicator());
        }
        if (pageState == PageState.ERROR) {
          resWidget = Center(
              child: widget.error ?? _messageWidget(value?.item3 ?? 'error'));
        }
        if (pageState == PageState.EMPTY) {
          resWidget = Center(
              child: widget.empty ?? _messageWidget(value?.item3 ?? 'empty'));
        }
        if (pageState == PageState.LOGIN) {
          resWidget = Center(
              child:
                  widget.noLogin ?? _messageWidget(value?.item3 ?? 'no login'));
        }
        if (pageState == PageState.CONTENT) {
          resWidget = widget.builder(context, value.item2);
        }
        return SmartRefresher(
          controller: widget.provider.refreshController,
          onRefresh:
              widget.provider.isRefresh ? widget.provider.onRefresh : null,
          onLoading:
              widget.provider.isLoadMore ? widget.provider.onLoadMore : null,
          header: widget.provider.headerWidget,
          footer: widget.provider.footWidget,
          enablePullUp: widget.provider.isLoadMore,
          enablePullDown: widget.provider.isRefresh,
          child: resWidget ?? Container(),
        );
      },
      selector: (_, P provider) => Tuple3<PageState, M, String>(
          provider.pageState, provider.m, provider.msg),
    );
    return ChangeNotifierProvider<P>.value(
      value: widget.provider,
      child: selector,
    );
  }

  Widget _messageWidget(String s) {
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

  void getInfo() {}

  ///empty
  void setEmpty({String msg}) {
    if (_pageState == PageState.EMPTY) {
      return;
    }
    _pageState = PageState.EMPTY;
    _msg = _msg;
    notifyListeners();
  }

  void onError(dynamic e) {
    if (m is List && (m as List).isEmpty) {
      _pageState = PageState.EMPTY;
      _refreshController.loadFailed();
      return;
    }
    _refreshController.refreshFailed();
    _refreshController.loadFailed();
    setError();
  }

  ///error
  void setError({String msg}) {
    if (_pageState == PageState.ERROR) {
      return;
    }
    _pageState = PageState.ERROR;
    _msg = _msg;
    resetRefreshController();
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
    if (m is List && m.length == 0) {
      _pageState = PageState.EMPTY;
    } else {
      _pageState = PageState.CONTENT;
    }
    notifyListeners();
  }

  void resetRefreshController({bool noData = false}) {
    refreshController.refreshCompleted();
    if (noData) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    debugPrint("[PROVIDER] dispose!!");
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

mixin Parame {}

class LoadMoreParame with Parame {
  int page = 0;
  int size = 1;
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
    hideFooterWhenNotFull: true,
  );
}
