// 登录请求
import 'package:flutter/material.dart';

class Login {
  String phone;
  String email;
  String password;
  String code;

  Login({
    this.phone,
    this.email,
    @required this.password,
    @required this.code
  });

  factory Login.fromJson(Map<String, dynamic> json) =>
      Login(
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "phone":phone,
    "email": email,
    "password": password,
    "code":code
  };
}

// 登录返回
class LoginResponse {
  String accessToken;

  LoginResponse({@required this.accessToken,});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>LoginResponse(accessToken: json["access_token"],);

  Map<String, dynamic> toJson() => { "access_token": accessToken,};
}