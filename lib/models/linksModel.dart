// To parse this JSON data, do
//
//     final linksModel = linksModelFromJson(jsonString);

import 'dart:convert';

LinksModel linksModelFromJson(String str) => LinksModel.fromJson(json.decode(str));

String linksModelToJson(LinksModel data) => json.encode(data.toJson());

class LinksModel {
  String code;
  bool status;
  String message;
  Result result;

  LinksModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory LinksModel.fromJson(Map<String, dynamic> json) => LinksModel(
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
  String name;
  String importantLink;
  String status;
  String createdBy;
  String createdIp;
  DateTime createdDatetime;
  String modifiedBy;
  String modifiedIp;
  DateTime modifiedDatetime;

  Detail({
    required this.id,
    required this.name,
    required this.importantLink,
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
    name: json["name"],
    importantLink: json["important_link"],
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
    "name": name,
    "important_link": importantLink,
    "status": status,
    "created_by": createdBy,
    "created_ip": createdIp,
    "created_datetime": createdDatetime.toIso8601String(),
    "modified_by": modifiedBy,
    "modified_ip": modifiedIp,
    "modified_datetime": modifiedDatetime.toIso8601String(),
  };
}
