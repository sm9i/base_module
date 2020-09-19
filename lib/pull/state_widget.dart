import 'package:base_module/pull/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuple/tuple.dart';

typedef StateBuilder<M> = Widget Function(BuildContext context, M m);

///多状态布局
///[provider] 需要的provider
///[P] 继承自[SingleProvider] 的provider
///[M] 页面需要的主要数据
///[builder]build 页面提供[M]
///[empty] 当页面是空的时候展示的页面
///[error] 当页面是error
///[noLogin] 未登录
///[loading] loading
///[autoDispose] 是否自动dispose
class MultiStateWidget<P extends SingleProvider<M>, M> extends StatefulWidget {
  const MultiStateWidget({
    Key key,
    @required this.provider,
    @required this.builder,
    this.empty,
    this.error,
    this.noLogin,
    this.loading,
    this.autoDispose = true,
    this.emptyBuilder,
    this.errorBuilder,
    this.noLoginBuilder,
  }) : super(key: key);

  ///需要监听的provider
  final P provider;

  ///当主要数据 获取到后
  final StateBuilder<M> builder;

  final StateBuilder<String> emptyBuilder;
  final StateBuilder<String> errorBuilder;
  final StateBuilder<String> noLoginBuilder;

  @Deprecated('过期的垃圾方法')
  final Widget empty;
  @Deprecated('过期的垃圾方法')
  final Widget error;
  @Deprecated('过期的垃圾方法')
  final Widget noLogin;
  @Deprecated('过期的垃圾方法')
  final Widget loading;

  ///是否需要自动dispose
  ///可以提供外部自己dispose
  final bool autoDispose;

  @override
  _MultiStateWidgetState<P, M> createState() => _MultiStateWidgetState<P, M>();
}

class _MultiStateWidgetState<P extends SingleProvider<M>, M> extends State<MultiStateWidget<P, M>> {
  ConfigState configState;

  @override
  void initState() {
    widget.provider.getInfo();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    configState = ConfigState.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.provider.dispose();
    }
    super.dispose();
  }

  Widget loadingWidget() {
    Widget res;
    if (widget.loading != null) {
      res = widget.loading;
    } else if (configState != null && configState.loadingWidget != null) {
      res = configState.loadingWidget;
    } else {
      res = const CupertinoActivityIndicator();
    }
    return Center(child: res);
  }

  Widget errorWidget({String error}) {
    Widget res;
    if (widget.errorBuilder != null) {
      res = widget.errorBuilder(context, error);
    } else if (configState != null && configState.errorWidget != null) {
      res = configState.errorWidget;
    } else {
      res = _messageWidget(error ?? 'error');
    }
    return Center(child: res);
  }

  Widget emptyWidget(BuildContext context, {String empty}) {
    Widget res;
    if (widget.emptyBuilder != null) {
      res = widget.emptyBuilder.call(context, empty);
    } else if (configState != null && configState.emptyWidget != null) {
      res = configState.emptyWidget;
    } else {
      res = _messageWidget(empty ?? 'empty');
    }
    return Center(child: res);
  }

  Widget noLoginWidget({String msg}) {
    Widget res;
    if (widget.noLoginBuilder != null) {
      res = widget.noLoginBuilder.call(context, msg);
    } else if (widget.noLogin != null) {
      res = widget.noLogin;
    } else if (configState != null && configState.noLoginWidget != null) {
      res = configState.noLoginWidget;
    } else {
      res = _messageWidget(msg ?? 'no login');
    }
    return Center(child: res);
  }

  @override
  Widget build(BuildContext context) {
    final Widget selector = Selector<P, Tuple3<PageState, M, String>>(
      builder: (BuildContext context, Tuple3<PageState, M, String> value, __) {
        final PageState pageState = value.item1;
        Widget resWidget;
        if (pageState == PageState.LOADING) {
          resWidget = loadingWidget();
        } else if (pageState == PageState.ERROR) {
          resWidget = errorWidget(error: value.item3);
        } else if (pageState == PageState.EMPTY) {
          resWidget = emptyWidget(context, empty: value.item3);
        } else if (pageState == PageState.LOGIN) {
          resWidget = noLoginWidget(msg: value.item3);
        } else if (pageState == PageState.CONTENT) {
          resWidget = widget.builder(context, value.item2);
        }
        return SmartRefresher(
          controller: widget.provider.refreshController,
          onRefresh: widget.provider.isRefresh ? widget.provider.onRefresh : null,
          onLoading: widget.provider.isLoadMore ? widget.provider.onLoadMore : null,
          header: widget.provider.headerWidget,
          footer: widget.provider.footWidget,
          enablePullUp: widget.provider.isLoadMore && pageState == PageState.CONTENT,
          enablePullDown: widget.provider.isRefresh,
          child: resWidget ?? Container(),
        );
      },
      selector: (_, P provider) => Tuple3<PageState, M, String>(provider.pageState, provider.m, provider.msg),
//      shouldRebuild: (Tuple3<PageState, M, String> p1, Tuple3<PageState, M, String> p2) {
//        print('p1${p1.toString()}');
//        print('p2${p2.toString()}');
//        return p1 != p2;
//      },
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

///用来控制页面的provider
///[getInfo]
abstract class SingleProvider<M> extends ChangeNotifier {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  ///当页面是非正常布局的msg
  String _msg;

  ///页面当前的状态 默认为加载中
  PageState _pageState = PageState.LOADING;

  ///页面需要的主要数据
  M _m;

  ///请求所需要的参数 如果需要监听就需要重写==
  ProviderParameter get parameter => null;

  ///如果需要下拉刷新重写此方法
  ///并且super放在最后一行否则不会请求数据
  void onRefresh() {
//    if (parameter is LoadMoreParameter) {
//      (parameter as LoadMoreParameter).page =1;
//    }
    getInfo();
  }

  ///如果需要上拉加载重写此方法
  ///并且super放在最后一行否则不会请求数据
  void onLoadMore() {
    //    if (parameter is LoadMoreParameter) {
//      (parameter as LoadMoreParameter).page += 1;
//    }
    getInfo();
  }

  ///获取数据方法
  ///必须重写调用
  ///熙增checkLoading 是否在刷新前loading 必须在获取数据前super;
  @mustCallSuper
  void getInfo([bool checkLoading = false]) {
    if (checkLoading) {
      setLoading();
    }
  }

  ///设置布局为空
  void setEmpty({String msg}) {
    if (_pageState == PageState.EMPTY && _msg == msg) {
      return;
    }
    _pageState = PageState.EMPTY;
    _msg = msg;
    notifyListeners();
  }

  ///处理error一般重写
  void onError(dynamic e) {
    if (m is List && (m as List).isEmpty) {
      _pageState = PageState.EMPTY;
      _refreshController.loadFailed();
      return;
    }
    _refreshController.refreshFailed();
    _refreshController.loadFailed();
    setError();
    debugPrint('[PROVIDER] onError!!');
  }

  ///设置布局为Error
  void setError({String msg}) {
    if (_pageState == PageState.ERROR && _msg == msg) {
      return;
    }
    _pageState = PageState.ERROR;
    _msg = msg;
    notifyListeners();
  }

  ///设置布局为未登录
  void setNoLogin({String msg}) {
    if (_pageState == PageState.LOGIN && _msg == msg) {
      return;
    }
    _pageState = PageState.LOGIN;
    _msg = msg;
    notifyListeners();
  }

  ///设置布局为加载中
  void setLoading() {
    if (_pageState == PageState.LOADING && _msg == msg) {
      return;
    }
    _pageState = PageState.LOADING;
    _msg = msg;
    notifyListeners();
  }

  ///设置数据页面
  ///如果数据为list 就会判断数据长度是否为0
  ///[checkList]是否通过判断m是list然后去给定空界面
  void setContent(M m, {bool checkList = true}) {
    _m = m;
    if (m is List && m.length == 0 && checkList) {
      _pageState = PageState.EMPTY;
    } else {
      _pageState = PageState.CONTENT;
    }
    notifyListeners();
  }

  ///重置controller
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
    debugPrint('[PROVIDER] dispose!!');
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  M get m => _m;

  String get msg => _msg;

  PageState get pageState => _pageState;

  RefreshController get refreshController => _refreshController;

  ScrollController get scrollController => _scrollController;

  //页面是否需要加载更多 默认true 不需要就重写为false
  bool get isLoadMore => true;

//页面是否需要下拉刷新 默认true 不需要就重写为false
  bool get isRefresh => true;

  Widget get headerWidget => const ClassicHeader();

  Widget get footWidget => const ClassicFooter();
}

///请求参数
mixin ProviderParameter {}

///如果需要分页的参数
///如果需要toJson必须带page 和size
class LoadMoreParameter with ProviderParameter {
  ///默认分页从[page]开始 一页[size] 个
  LoadMoreParameter({this.page = 1, this.size = 15});

  int page;
  int size;
}

///页面状态
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
