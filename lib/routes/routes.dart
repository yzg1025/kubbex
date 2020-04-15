import 'package:Kkubex/routes/route_handles.dart';
import 'package:Kkubex/view/login_reg_forget/login_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes{
  static String root ='/';
  static String home = '/home';
  static String login = '/login'; 
  static String selectcode = '/selectcode'; 

  static void configureRoutes(Router router){
    router.notFoundHandler = new Handler(
      handlerFunc:(BuildContext context, Map<String,List<String>> param){
        print('找不到当前路由');
        return LoginPage();
      }
    );

    router.define(root, handler: splashHandle);
    router.define(login, handler: loginHandle);
    router.define(selectcode, handler: selectcodeHandle);
    router.define(home, handler: homeHandle);
  }
}