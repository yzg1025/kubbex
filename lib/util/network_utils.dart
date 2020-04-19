import 'dart:convert';
import 'dart:io';

import 'package:Kkubex/global.dart';
import 'package:Kkubex/model/area_code.dart';
import 'package:Kkubex/model/login.dart';
import 'package:Kkubex/model/notic.dart';
import 'package:Kkubex/model/registermodel.dart';
import 'package:Kkubex/util/navigator_util.dart';
import 'package:Kkubex/util/proxy.dart';
import 'package:Kkubex/util/url.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showToast(String msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER,backgroundColor: Colors.grey);
  }
}

class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  Dio dio;
  CancelToken cancelToken = new CancelToken();

  HttpUtil._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = new BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: SERVER_API_URL,
      connectTimeout: 10000,
      receiveTimeout: 5000,

      // Http请求头.
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = new Dio(options);

    // Cookie管理
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return options; //continue
    }, onResponse: (Response response) {
      return response; // continue
    }, onError: (DioError e) {
      ErrorEntity eInfo = createErrorEntity(e);
      // 错误提示
      Utils.showToast('登录失效，请重新登录');
      // 错误交互处理
      var context = e.request.extra["context"];
      if (context != null) {
        switch (eInfo.code) {
          case 401: // 没有权限 重新登录
            NavigatorUtil.goLoginPage(context);
            break;
          default:
        }
      }
      return eInfo;
    }));

    // 加内存缓存
    //dio.interceptors.add(NetCache());

    //在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!Global.isRelease && PROXY_ENABLE) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return "PROXY $PROXY_IP:$PROXY_PORT";
        };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  /*
   * error统一处理
   */
  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return ErrorEntity(code: -1, message: "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            switch (errCode) {
              case 400:
                {
                  return ErrorEntity(code: errCode, message: "请求语法错误");
                }
                break;
              case 401:
                {
                  return ErrorEntity(code: errCode, message: "没有权限");
                }
                break;
              case 403:
                {
                  return ErrorEntity(code: errCode, message: "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return ErrorEntity(code: errCode, message: "无法连接服务器");
                }
                break;
              case 405:
                {
                  return ErrorEntity(code: errCode, message: "请求方法被禁止");
                }
                break;
              case 500:
                {
                  return ErrorEntity(code: errCode, message: "服务器内部错误");
                }
                break;
              case 502:
                {
                  return ErrorEntity(code: errCode, message: "无效的请求");
                }
                break;
              case 503:
                {
                  return ErrorEntity(code: errCode, message: "服务器挂了");
                }
                break;
              case 505:
                {
                  return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  return ErrorEntity(
                      code: errCode, message: error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "未知错误");
          }
        }
        break;
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  // 读取本地配置
  // Map<String, dynamic> getAuthorizationHeader() {
  //   var headers;
  //   String accessToken = Global.profile?.accessToken;
  //   if (accessToken != null) {
  //     headers = {
  //       'Authorization': 'Bearer $accessToken',
  //     };
  //   }
  //   return headers;
  // }

  /// restful post 操作
  Future post(
    String path, {
    @required BuildContext context,
    dynamic params,
    Options options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.merge(extra: {
      "context": context,
    });
    // Map<String, dynamic> _authorization = getAuthorizationHeader();
    // if (_authorization != null) {
    //   requestOptions = requestOptions.merge(headers: _authorization);
    // }
    var response = await dio.post(path, data: params, options: requestOptions, cancelToken: cancelToken);
    return jsonDecode(response.data);
  }

}

// 异常处理
class ErrorEntity implements Exception {
  int code;
  String message;
  ErrorEntity({this.code, this.message});

  String toString() {
    if (message == null) return "Exception";
    return "Exception: code $code, $message";
  }
}

class UserAPI {
  //区号
  static Future<AreaCode> getCountries({BuildContext context}) async {
    var params = {'is_debug':'true'};
    Map<String, dynamic>.from(params);
    var response = await HttpUtil().post('/api/Login/getCountryPhoneCode',context: context,params:params);
    return AreaCode.fromJson(response);
  }
  /// 公告
  static Future<Notice> getNotice({BuildContext context}) async {
    var params = {'is_debug':'true'};
    Map<String, dynamic>.from(params);
    var response = await HttpUtil().post('/api/Announces/getAnnounceList',context: context, params: params);
    return Notice.fromJson(response);
  }

  ///登录
  static Future<LoginResponse> login({BuildContext context,Login params}) async {
    var response = await HttpUtil().post('/api/Login/login',context: context, params: params);
    return LoginResponse.fromJson(response);
  }

  ///获取验证码
  static Future<GetCodeResponse> getCode({BuildContext context,GetCodeRequire params}) async {
    var response = await HttpUtil().post('/api/Login/send_verification_code',context: context, params: params);
    return GetCodeResponse.fromJson(response);
  }

  //注册
  static Future<GetCodeResponse> getRegister({BuildContext context,RegisterRequire params}) async {
    var response = await HttpUtil().post('/api/Login/register',context: context, params: params);
    return GetCodeResponse.fromJson(response);
  }

  //忘记密码
  static Future<GetCodeResponse> getForgetPass({BuildContext context,Login params}) async {
    var response = await HttpUtil().post('/api/Login/forget',context: context, params: params);
    return GetCodeResponse.fromJson(response);
  }
}
