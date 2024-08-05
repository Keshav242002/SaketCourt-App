// To parse this JSON data, do
//
//     final orderIdModel = orderIdModelFromJson(jsonString);

import 'dart:convert';

OrderIdModel orderIdModelFromJson(String str) => OrderIdModel.fromJson(json.decode(str));

String orderIdModelToJson(OrderIdModel data) => json.encode(data.toJson());

class OrderIdModel {
  int code;
  bool status;
  String message;

  OrderIdModel({
    required this.code,
    required this.status,
    required this.message,
  });

  factory OrderIdModel.fromJson(Map<String, dynamic> json) => OrderIdModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
  };
}
