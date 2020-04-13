import 'package:Kkubex/routes/navigate_service.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Application{
  static Router router;
  static GlobalKey<NavigatorState> key = GlobalKey();
  static double screenWidth;
  static double screenHeight;
  static GetIt getTt = GetIt.instance;

  static setupLocator(){
    getTt.registerSingleton(NavigateService());
  }

  static getIt() {}
}