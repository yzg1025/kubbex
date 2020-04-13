import 'package:Kkubex/application.dart';
import 'package:Kkubex/routes/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class NavigatorUtil{
  static _navigateTo(BuildContext context,String path,
  {bool replace = false,bool clearStack = false,
  Duration transitionDuration =const Duration(milliseconds:250),
  RouteTransitionsBuilder transitionBuilder}){
    Application.router.navigateTo(context, path,
      replace:replace,
      clearStack: clearStack,
      transitionDuration: transitionDuration,
      transitionBuilder:transitionBuilder,
      transition:TransitionType.material
    );
  }
  
  ///登录页面
  static void goLoginPage(BuildContext context){
    _navigateTo(context, Routes.login,clearStack: true);
  }

  ///首页页面
  static void goIndexPage(BuildContext context){
    _navigateTo(context, Routes.home,clearStack: true);
  }
}