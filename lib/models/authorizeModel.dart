// To parse this JSON data, do
//
//     final authorizeModel = authorizeModelFromJson(jsonString);

import 'dart:convert';

AuthorizeModel authorizeModelFromJson(String str) => AuthorizeModel.fromJson(json.decode(str));

String authorizeModelToJson(AuthorizeModel data) => json.encode(data.toJson());

class AuthorizeModel {
  String code;
  String message;
  bool status;
  String token;

  AuthorizeModel({
    required this.code,
    required this.message,
    required this.status,
    required this.token,
  });

  factory AuthorizeModel.fromJson(Map<String, dynamic> json) => AuthorizeModel(
    code: json["code"],
    message: json["message"],
    status: json["status"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "status": status,
    "token": token,
  };
}
