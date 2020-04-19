import 'package:Kkubex/routes/route_handles.dart';
import 'package:Kkubex/util/network_utils.dart';
import 'package:Kkubex/view/login_reg_forget/login_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes{
  static String root ='/';
  static String home = '/home';
  static String login = '/login'; 
  static String selectcode = '/selectcode'; 
  static String register = '/register'; 
  static String forget = '/forget'; 

  static void configureRoutes(Router router){
    router.notFoundHandler = new Handler(
      handlerFunc:(BuildContext context, Map<String,List<String>> param){
        Utils.showToast('添加新路由，请重新启动项目');
        return LoginPage();
      }
    );

    router.define(root, handler: splashHandle);
    router.define(login, handler: loginHandle);
    router.define(selectcode, handler: selectcodeHandle);
    router.define(home, handler: homeHandle);
    router.define(register, handler: registerHandle);
    router.define(forget, handler: forgetHandle);
  }
}