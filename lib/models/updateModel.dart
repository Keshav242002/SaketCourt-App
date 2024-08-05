// To parse this JSON data, do
//
//     final updateModel = updateModelFromJson(jsonString);

import 'dart:convert';

UpdateModel updateModelFromJson(String str) => UpdateModel.fromJson(json.decode(str));

String updateModelToJson(UpdateModel data) => json.encode(data.toJson());

class UpdateModel {
  int code;
  bool status;
  String message;
  Result result;

  UpdateModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
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
  int id;

  Detail({
    required this.id,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
