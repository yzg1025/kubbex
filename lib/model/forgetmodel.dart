class Forget {
  bool is_debug;
  int accounttype;
  String account;

  Forget({
    this.is_debug,
    this.accounttype,
    this.account,
  });

  factory Forget.fromJson(Map<String, dynamic> json) =>
      Forget(
        is_debug: json["is_debug"],
        accounttype: json["accounttype"],
        account: json["account"],
      );

  Map<String, dynamic> toJson() => {
    "is_debug": is_debug,
    "accounttype": accounttype,
    "account":account,
  };
}

class ForgetResponse {
  int code;
  String message;
  String messageCode;

  ForgetResponse({this.code,this.message, this.messageCode});

  ForgetResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    messageCode = json['message_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['message_code'] = this.messageCode;
    return data;
  }
}


class RegisterRequire {
  bool is_debug;
  int accounttype;
  String account;
  String password;
  String pay_password;
  String code;
  String invite;

  RegisterRequire({
    this.is_debug,
    this.accounttype,
    this.account,
    this.password,
    this.pay_password,
    this.code,
    this.invite
  });

  factory RegisterRequire.fromJson(Map<String, dynamic> json) =>
      RegisterRequire(
        is_debug: json["is_debug"],
        accounttype: json["accounttype"],
        account: json["account"],
        password: json["password"],
        pay_password: json["pay_password"],
        code: json["code"],
        invite: json["invite"],
      );

  Map<String, dynamic> toJson() => {
    "is_debug": is_debug,
    "accounttype": accounttype,
    "account":account,
    "password":password,
    "pay_password":pay_password,
    "code":code,
    "invite":invite,
  };
}