import 'package:flutter/material.dart';
import 'package:jellyflut/components/BackButton.dart' as back_button;
import 'package:jellyflut/main.dart';

class DetailHeaderBar extends StatelessWidget {
  final double height;
  final Color color;
  final bool showDarkGradient;

  DetailHeaderBar(
      {Key? key,
      required this.height,
      required this.color,
      this.showDarkGradient = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var statusBarHeight =
        MediaQuery.of(navigatorKey.currentContext!).padding.top;
    return Container(
      height: statusBarHeight + height,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: showDarkGradient
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black87,
                  Colors.black45,
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.8, 1],
              ),
            )
          : BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [back_button.BackButton()],
      ),
    );
  }
}
