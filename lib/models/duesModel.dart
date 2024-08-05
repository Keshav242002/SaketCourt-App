import 'dart:convert';

DuesModel duesModelFromJson(String str) => DuesModel.fromJson(json.decode(str));

String duesModelToJson(DuesModel data) => json.encode(data.toJson());

class DuesModel {
  String? code;
  bool? status;
  String? message;
  int? totalDues;

  DuesModel({
    this.code,
    this.status,
    this.message,
    this.totalDues,
  });

  factory DuesModel.fromJson(Map<String, dynamic> json) => DuesModel(
    code: json["code"] ?? '',
    status: json["status"] ?? false,
    message: json["message"] ?? '',
    totalDues: json["total_dues"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "total_dues": totalDues,
  };
}
