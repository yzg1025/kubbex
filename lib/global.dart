import 'package:Kkubex/util/network_utils.dart';
import 'package:Kkubex/util/shared_preferences.dart';
import 'package:Kkubex/util/url.dart';
import 'package:flutter/material.dart';

import 'model/login.dart';

/// 全局配置
class Global {
  /// 用户配置
  static LoginResponse userProfile = LoginResponse(
    data: null,
  );

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
  }

  //持久化 用户信息
  static Future<bool> saveProfile(LoginResponse userResponse) {
    userProfile = userResponse.data.token as LoginResponse;
    return StorageUtil().setJSON(STORAGE_USER_PROFILE_KEY, userResponse.data.token);
  }
}