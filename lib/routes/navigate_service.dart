import 'package:flutter/material.dart';

class NavigateService{
  ///意义 在不使用BuildContext的情况下进行页面跳转
  final GlobalKey<NavigatorState> key = GlobalKey(debugLabel:'navigate_key');

  NavigatorState get navigator => key.currentState;

  get pushNamed => navigator.pushNamed;
  get push => navigator.push;
  get popAndPushNamed => navigator.popAndPushNamed;
}