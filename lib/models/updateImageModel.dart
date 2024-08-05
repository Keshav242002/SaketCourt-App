// To parse this JSON data, do
//
//     final updateImageModel = updateImageModelFromJson(jsonString);

import 'dart:convert';

UpdateImageModel updateImageModelFromJson(String str) => UpdateImageModel.fromJson(json.decode(str));

String updateImageModelToJson(UpdateImageModel data) => json.encode(data.toJson());

class UpdateImageModel {
  int code;
  bool status;
  String message;
  Result result;

  UpdateImageModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory UpdateImageModel.fromJson(Map<String, dynamic> json) => UpdateImageModel(
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
  String image;

  Detail({
    required this.id,
    required this.image,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"] ?? '',
    image: json["member_image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "member_image": image,
  };
}
