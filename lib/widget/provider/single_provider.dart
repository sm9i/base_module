part of 'single_widget.dart';

abstract class _SingleProvider<T> extends ChangeNotifier {
  final RefreshController refreshController = RefreshController();
  final WidgetProvider widgetProvider = WidgetProvider();

  void onInfoSuccess() {
    widgetProvider.changeState(WidgetState.CONTENT);
    notifyListeners();
  }

  void onInfoError({dynamic msg}) {
    widgetProvider.changeState(WidgetState.ERROR,msg: msg);
    notifyListeners();
  }

  T _info;

  ///获取数据
  Future<T> getInfo();

  ///下拉刷新和加载更多默认null 表示没有下拉刷新
  Future<void> onRefresh() => null;

  ///下拉刷新和加载更多默认null 表示没有下拉刷新
  Future<void> onLoad() => null;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  T get info => _info;
}
