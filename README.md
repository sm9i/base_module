# base_module

使用[Provider](https://pub.dev/packages/provider)控制页面的状态
    -未登录、加载中、异常、空、

```dart
  class _ContractProvider extends DefaultProvider<String> {
    _ContractProvider(this.url);
  
    final String url;
    final CommonModel _commonModel = CommonModel();
    
    ///获取数据的主要方法
    ///[checkLoading] 表示在加载的时候是否需要loading一下 仅主动
    @override
    void getInfo([bool checkLoading = false]) {
      ///实现loading
      super.getInfo(checkLoading);
      _commonModel.getContractByUrl(url).then((BaseInfo value) {
        if (value.code != successCode) {
          toast(value?.msg);
          return;
        }
        if (value.data is Map) {
          setContent(value.data['content'].toString());
        } else {
          setContent(value.data.toString());
        }
      ///onError 为 重写 SingleProvider自定义 onError 异常处理
      }).catchError(onError);
    }
  
    ///控制是否需要下拉刷新 如果需要刷新 需要重写 onRefresh方法
    @override
    bool get isRefresh => false;
    ///同上
    @override
    bool get isLoadMore => false;
    ///请求需要的参数
    @override
    WalletOrderParam get parameter => _param;

  }
```
简单的异常处理 可自己重写实现具体方法 也可重写onRefresh 方法
```dart
  @override
  void onError(dynamic e) {
    refreshController.loadFailed();
    refreshController.refreshFailed();
    if (e is BaseError) {
      switch (e.errorCode) {
        case ErrorCode.convert:
          toast('数据异常');
          setError(msg: e?.errorMsg ?? '数据异常');
          break;
        case ErrorCode.network:
          toast('网络异常');
          setError(msg: e?.errorMsg ?? '网络异常');
          break;
        case ErrorCode.login:
          setNoLogin(msg: '暂未登录');
          break;
      }
    } else {
      setError();
      debugPrint(e.toString());
    }
  }
```
对于有参数的接口
```dart
  class WalletOrderParam extends LoadMoreParameter {
    WalletOrderParam({
      this.time,
      this.sign,
      this.userId,
    ///对于有的后台是 0 开始 等等。。。默认是 1 15
    }) : super(page: 1, size: 15);
  
    String time;
    String sign;
    int userId;
    ///重写toJson 在 请求的时候直接 toJson
    ///可以使用法老的软生成
    Map<String, dynamic> toJson() => <String, dynamic>{
          'time': time,
          'sign': sign,
          'page': page,
          'size': size,
          'user_id': userId,
        };
} 

```
