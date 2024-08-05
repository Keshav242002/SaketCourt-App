

import 'dart:convert';

ForgetPasswordModel forgetPasswordModelFromJson(String str) => ForgetPasswordModel.fromJson(json.decode(str));

String forgetPasswordModelToJson(ForgetPasswordModel data) => json.encode(data.toJson());

class ForgetPasswordModel {
  int code;
  bool status;
  String message;
  List<Datum> data;

  ForgetPasswordModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) => ForgetPasswordModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String password;

  Datum({
    required this.password,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "password": password,
  };
}
