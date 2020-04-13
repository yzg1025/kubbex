import 'package:Kkubex/util/network_utils.dart';
import 'package:Kkubex/util/shared_preferences.dart';
import 'package:flutter/material.dart';

/// 全局配置
class Global {
  /// 用户配置
  // static UserLoginResponseEntity profile = UserLoginResponseEntity(
  //   accessToken: null,
  // );

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 应用状态
  //static AppState appState = AppState();

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 工具初始
    await StorageUtil.init();
    HttpUtil();

    // 读取设备第一次打开
    // isFirstOpen = !StorageUtil().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
    // if (isFirstOpen) {
    //   StorageUtil().setBool(STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    // }

    // // 读取离线用户信息
    // var _profileJSON = StorageUtil().getJSON(STORAGE_USER_PROFILE_KEY);
    // if (_profileJSON != null) {
    //   profile = UserLoginResponseEntity.fromJson(_profileJSON);
    //   isOfflineLogin = true;
    // }

    // android 状态栏为透明的沉浸
    // if (Platform.isAndroid) {
    //   SystemUiOverlayStyle systemUiOverlayStyle =
    //       SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // }
  }

  // 持久化 用户信息
  // static Future<bool> saveProfile(UserLoginResponseEntity userResponse) {
  //   profile = userResponse;
  //   return StorageUtil()
  //       .setJSON(STORAGE_USER_PROFILE_KEY, userResponse.toJson());
  // }
}