// To parse this JSON data, do
//
//     final circularModel = circularModelFromJson(jsonString);

import 'dart:convert';

CircularModel circularModelFromJson(String str) => CircularModel.fromJson(json.decode(str));

String circularModelToJson(CircularModel data) => json.encode(data.toJson());

class CircularModel {
  String code;
  bool status;
  String message;
  Result result;

  CircularModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory CircularModel.fromJson(Map<String, dynamic> json) => CircularModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class Result {
  List<Detail> details;

  Result({
    required this.details,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Detail {
  String id;
  String uploadCircular;
  DateTime dateOfUploading;
  String status;
  String createdBy;
  String createdIp;
  DateTime createdDatetime;
  String modifiedBy;
  String modifiedIp;
  DateTime modifiedDatetime;

  Detail({
    required this.id,
    required this.uploadCircular,
    required this.dateOfUploading,
    required this.status,
    required this.createdBy,
    required this.createdIp,
    required this.createdDatetime,
    required this.modifiedBy,
    required this.modifiedIp,
    required this.modifiedDatetime,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    uploadCircular: json["upload_circular"],
    dateOfUploading: DateTime.parse(json["date_of_uploading"]),
    status: json["status"],
    createdBy: json["created_by"],
    createdIp: json["created_ip"],
    createdDatetime: DateTime.parse(json["created_datetime"]),
    modifiedBy: json["modified_by"],
    modifiedIp: json["modified_ip"],
    modifiedDatetime: DateTime.parse(json["modified_datetime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "upload_circular": uploadCircular,
    "date_of_uploading": "${dateOfUploading.year.toString().padLeft(4, '0')}-${dateOfUploading.month.toString().padLeft(2, '0')}-${dateOfUploading.day.toString().padLeft(2, '0')}",
    "status": status,
    "created_by": createdBy,
    "created_ip": createdIp,
    "created_datetime": createdDatetime.toIso8601String(),
    "modified_by": modifiedBy,
    "modified_ip": modifiedIp,
    "modified_datetime": modifiedDatetime.toIso8601String(),
  };
}
