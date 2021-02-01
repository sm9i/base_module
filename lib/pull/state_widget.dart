// import 'package:base_module/pull/config.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:tuple/tuple.dart';
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef StateBuilder<M> = Widget Function(BuildContext context, M m);

class MultiStateWidget extends StatefulWidget {
  @override
  _MultiStateWidgetState createState() => _MultiStateWidgetState();
}

class _MultiStateWidgetState extends State<MultiStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

abstract class SingleGet<M> extends GetxController {
  Rx<PageState> _pageState;

  Rx<M> _m;

  @mustCallSuper
  void getInfo([bool checkLoading = false]) {
    if (checkLoading) {
      setLoading();
    }
  }

  void setContent(M m, {bool checkList = true}) {
    if (m is List && m.length == 0 && checkList && _pageState.canUpdate) {
      _pageState.update((PageState val) {
        val = PageState.EMPTY;
      });
    } else {
      if (_pageState.canUpdate) {
        _pageState.update((PageState val) {
          val = PageState.CONTENT;
        });
      }
      if (_m.canUpdate) {
        _m.update((M val) {
          val = m;
        });
      }
    }
  }

  void setLoading() {
    if (_pageState.value == PageState.LOADING) {
      return;
    }
    if (_pageState.canUpdate) {
      _pageState.update((PageState val) {
        val = PageState.LOADING;
      });
    }
  }

  void setEmpty() {
    if (_pageState.value == PageState.EMPTY) {
      return;
    }
    if (_pageState.canUpdate) {
      _pageState.update((PageState val) {
        val = PageState.EMPTY;
      });
    }
  }

  void setError() {
    if (_pageState.value == PageState.ERROR) {
      return;
    }
    if (_pageState.canUpdate) {
      _pageState.update((PageState val) {
        val = PageState.ERROR;
      });
    }
  }

  bool get isLoadMore => false;

  bool get isRefresh => true;
}

enum PageState {
  EMPTY,
  LOADING,
  CONTENT,
  LOGIN,
  ERROR,
}

Widget configRefresh(Widget child) {
  return RefreshConfiguration(child: child, hideFooterWhenNotFull: true);
}
