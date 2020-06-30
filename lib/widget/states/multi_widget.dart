import 'package:base_module/widget/states/state_widget.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';

///状态builder实例
typedef StateBuilder = Widget Function(dynamic msg);

class MultiWidget extends StatelessWidget {
  const MultiWidget({
    @required this.provider,
    Key key,
    this.emptyBuilder,
    this.errorBuilder,
    @required this.content,
  }) : super(key: key);

  final WidgetProvider provider;

  ///当布局是empty的时候
  final StateBuilder emptyBuilder;

  ///当布局是error的时候
  final StateBuilder errorBuilder;

  ///展会内容
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WidgetProvider>(
      create: (_) => provider,
      child: Consumer<WidgetProvider>(
        builder: (_, WidgetProvider value, __) {
          ///loading
          if (value._state == WidgetState.LOADING) {
            return LoadWidget();
          }

          ///empty
          if (value._state == WidgetState.EMPTY) {
            Widget res;
            if (emptyBuilder == null) {
              res = const EmptyWidget(msg: 'empty');
            } else {
              res = emptyBuilder(value.msg);
            }
            return res;
          }

          ///error
          if (value._state == WidgetState.ERROR) {
            Widget res;
            if (errorBuilder == null) {
              res = const ErrorWidget(msg: 'error');
            } else {
              res = errorBuilder(value.msg);
            }
            return res;
          }
          return content;
        },
      ),
    );
  }
}

class WidgetProvider extends ChangeNotifier {
  WidgetState _state = WidgetState.LOADING;
  dynamic msg;

  ///切换状态
  void changeState(WidgetState state, {dynamic msg}) {
    if (_state == state) {
      return;
    }
    _state = state;
    msg = msg;
    notifyListeners();
  }

  WidgetState get state => _state;
}

enum WidgetState { EMPTY, ERROR, CONTENT, LOADING }
