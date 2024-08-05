import 'dart:convert';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  String code;
  bool status;
  String message;
  int totalCount;
  Result result;

  SearchModel({
    required this.code,
    required this.status,
    required this.message,
    required this.totalCount,
    required this.result,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    totalCount: int.parse(json["total_count"]), // Parse the total_count as an integer
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "total_count": totalCount.toString(), // Convert the totalCount to a string for JSON
    "result": result.toJson(),
  };
}

class Result {
  List<Details> details;

  Result({
    required this.details,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json["details"] as List;
    List<Details> detailsList = list.map((i) => Details.fromJson(i)).toList();
    return Result(
      details: detailsList,
    );
  }

  Map<String, dynamic> toJson() => {
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Details {
  String? image;
  String? memName;
  String? fatherName;
  String? email;
  String? mobile1;
  String? officeAdd1;
  String? officeAdd2;
  String? officeAdd3;
  String? resAdd1;
  String? resAdd2;
  String? resAdd3;
  String? membershipDate;
  String? enrlDate;
  String? dob;
  String? enrlNo;
  String? memNo;

  Details({
    this.image,
    this.memName,
    this.fatherName,
    this.email,
    this.mobile1,
    this.officeAdd1,
    this.officeAdd2,
    this.officeAdd3,
    this.resAdd1,
    this.resAdd2,
    this.resAdd3,
    this.membershipDate,
    this.enrlDate,
    this.dob,
    this.enrlNo,
    this.memNo,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    image: json["image"],
    memName: json["mem_name"],
    fatherName: json["father_name"],
    email: json["email"],
    mobile1: json["mobile1"],
    officeAdd1: json["office_add1"],
    officeAdd2: json["office_add2"],
    officeAdd3: json["office_add3"],
    resAdd1: json["res_add1"],
    resAdd2: json["res_add2"],
    resAdd3: json["res_add3"],
    membershipDate: json["membership_date"],
    enrlDate: json["enrl_date"],
    dob: json["dob"],
    enrlNo: json["enrl_no"],
    memNo: json['mem_code'],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "mem_name": memName,
    "father_name": fatherName,
    "email": email,
    "mobile1": mobile1,
    "office_add1": officeAdd1,
    "office_add2": officeAdd2,
    "office_add3": officeAdd3,
    "res_add1": resAdd1,
    "res_add2": resAdd2,
    "res_add3": resAdd3,
    "membership_date": membershipDate,
    "enrl_date": enrlDate,
    "dob": dob,
    "enrl_no": enrlNo,
    "mem_code": memNo,
  };
}
