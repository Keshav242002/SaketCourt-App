import 'dart:convert';

EventModel eventModelFromJson(String str) => EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  String code;
  bool status;
  String message;
  Result result;

  EventModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
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
  String eventName;
  DateTime eventDate;
  String? description; // Make description nullable
  String? image; // Make image nullable
  String status;
  String createdBy;
  String createdIp;
  DateTime createdDatetime;
  String? modifiedBy; // Make modifiedBy nullable
  String? modifiedIp; // Make modifiedIp nullable
  DateTime? modifiedDatetime; // Make modifiedDatetime nullable

  Detail({
    required this.id,
    required this.eventName,
    required this.eventDate,
    this.description,
    this.image,
    required this.status,
    required this.createdBy,
    required this.createdIp,
    required this.createdDatetime,
    this.modifiedBy,
    this.modifiedIp,
    this.modifiedDatetime,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    eventName: json["event_name"],
    eventDate: DateTime.parse(json["event_date"]),
    description: json["description"] == null ? null : json["description"],
    image: json["image"] == null ? null : json["image"],
    status: json["status"],
    createdBy: json["created_by"],
    createdIp: json["created_ip"],
    createdDatetime: DateTime.parse(json["created_datetime"]),
    modifiedBy: json["modified_by"] == null ? null : json["modified_by"],
    modifiedIp: json["modified_ip"] == null ? null : json["modified_ip"],
    modifiedDatetime: json["modified_datetime"] == null ? null : DateTime.parse(json["modified_datetime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_name": eventName,
    "event_date": eventDate.toIso8601String(),
    "description": description,
    "image": image,
    "status": status,
    "created_by": createdBy,
    "created_ip": createdIp,
    "created_datetime": createdDatetime.toIso8601String(),
    "modified_by": modifiedBy,
    "modified_ip": modifiedIp,
    "modified_datetime": modifiedDatetime?.toIso8601String(),
  };
}
