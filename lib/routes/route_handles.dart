
import 'package:Kkubex/view/index.dart';
import 'package:Kkubex/view/login_reg_forget/forget_page.dart';
import 'package:Kkubex/view/login_reg_forget/login_page.dart';
import 'package:Kkubex/view/login_reg_forget/register.dart';
import 'package:Kkubex/view/login_reg_forget/select_code.dart';
import 'package:Kkubex/view/splash/splash.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

///引导页面
var splashHandle = Handler(
   handlerFunc: (BuildContext context,Map<String,List<Object>> params){
     return SplashPage();
   }
);

///登录页面
var loginHandle = Handler(
   handlerFunc: (BuildContext context,Map<String,List<Object>> params){
     return LoginPage();
   }
);

///登录页面
var selectcodeHandle = Handler(
   handlerFunc: (BuildContext context,Map<String,List<Object>> params){
     return SelectCode();
   }
);

///注册页面
var registerHandle = Handler(
   handlerFunc: (BuildContext context,Map<String,List<Object>> params){
     return Register();
   }
);

///找回密码页面
var forgetHandle = Handler(
   handlerFunc: (BuildContext context,Map<String,List<Object>> params){
     return RegisterPage();
   }
);

///首页页面
var homeHandle = Handler(
   handlerFunc: (BuildContext context,Map<String,List<Object>> params){
     return IndexPage();
   }
);