// 登录请求
import 'package:flutter/material.dart';

class Login {
  bool is_debug;
  int accounttype;
  String account;
  String password;
  String repassword;
  String code;

  Login({
    this.is_debug,
    this.accounttype,
    this.account,
    this.repassword,
    this.code,
    @required this.password,
  });

  factory Login.fromJson(Map<String, dynamic> json) =>
      Login(
        is_debug: json["is_debug"],
        accounttype: json["accounttype"],
        account: json["account"],
        password: json["password"],
        repassword: json["repassword"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "is_debug": is_debug,
    "accounttype": accounttype,
    "account":account,
    "password": password,
    "repassword": repassword,
    "code": code,
  };
}

// 登录返回
class LoginResponse {
    int code;
    Data data;
    String message;

    LoginResponse({
        this.code,
        this.data,
        this.message,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    String token;
    int isConfirm;
    int isMobileConfirm;
    int isEmailConfirm;

    Data({
        this.token,
        this.isConfirm,
        this.isMobileConfirm,
        this.isEmailConfirm,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        isConfirm: json["is_confirm"],
        isMobileConfirm: json["is_mobile_confirm"],
        isEmailConfirm: json["is_email_confirm"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "is_confirm": isConfirm,
        "is_mobile_confirm": isMobileConfirm,
        "is_email_confirm": isEmailConfirm,
    };
}