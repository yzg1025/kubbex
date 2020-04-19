import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  String stroage = 'ducafcat_news_app';
  static final StorageUtil _singleton = new StorageUtil._internal();
  LocalStorage _storage;
  static SharedPreferences _prefs;

  factory StorageUtil() {
    return _singleton;
  }

  StorageUtil._internal() {
    _storage = new LocalStorage(stroage);
  }

  String getItem(String key) {
    return _storage.getItem(key);
  }

  Future<void> setItem(String key, String val) async {
    await _storage.setItem(key, val);
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs.setString(key, jsonString);
  }

  static Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
}