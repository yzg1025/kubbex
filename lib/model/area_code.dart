class AreaCode {
  int code;
  List<Datum> data;
  String message;

  AreaCode({this.code, this.data, this.message});

  AreaCode.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<Datum>();
      json['data'].forEach((v) {
        data.add(new Datum.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Datum {
  int countryId;
  int phoneCode;
  String english;
  String nameChinese;

  Datum({this.countryId, this.phoneCode, this.english, this.nameChinese});

  Datum.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    phoneCode = json['phone_code'];
    english = json['english'];
    nameChinese = json['name_chinese'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['phone_code'] = this.phoneCode;
    data['english'] = this.english;
    data['name_chinese'] = this.nameChinese;
    return data;
  }
}