import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class RefreshWidget extends StatefulWidget {
  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return PullToRefreshNotification(
      onRefresh: onRefresh,
      maxDragOffset: 50.0,
      child: CustomScrollView(
        physics: const AlwaysScrollableClampingScrollPhysics(),
        slivers: [
          PullToRefreshContainer((PullToRefreshScrollNotificationInfo info) {
            final double offset = info?.dragOffset ?? 0.0;
            final double opacity = offset / 50;
            print(info?.mode);
            return SliverToBoxAdapter(
              child: Container(
                height: offset,
                child: Opacity(
                  opacity: opacity,
                  child: const FlutterLogo(),
                ),
              ),
            );
          }),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('title'),
                  subtitle: Text('subTitle $index'),
                  trailing: Icon(Icons.face_outlined),
                );
              },
              childCount: 50,
            ),
          )
        ],
      ),
    );
  }

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(milliseconds: 2000), () {
      return true;
    });
  }
}
