

class ProfileModel {
  final Result result;

  ProfileModel({required this.result});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final List<Detail> details;

  Result({required this.details});

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['details'] as List;
    List<Detail> detailsList = list.map((i) => Detail.fromJson(i)).toList();
    return Result(details: detailsList);
  }
}

class Detail {
  final String? image;
  final String? memName;
  final String? fatherName;
  final String? memDate;
  final String? enrlDate;
  final String? enrlNum;
  final String? offAdd1;
  final String? offAdd2;
  final String? offAdd3;
  final String? resAdd1;
  final String? resAdd2;
  final String? resAdd3;
  final String? mobile1;
  final String? mobile2;
  final String? email;
  final String? memNo;
  final String? offTel;
  final String? resTel;
  final String? pwd;


  Detail({
    required this.image,
    required this.memName,
    required this.fatherName,
    required this.memDate,
    required this.enrlDate,
    required this.enrlNum,
    required this.mobile1,
    required this.mobile2,
    required this.email,
    required this.offAdd1,
    required this.offAdd2,
    required this.offAdd3,
    required this.resAdd1,
    required this.resAdd2,
    required this.resAdd3,
    required this.memNo,
    required this.offTel,
    required this.resTel,
    required this.pwd,


  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      image: json['image'] ?? '',
      memName: json['mem_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      memDate: json['dom'] ?? '',
      enrlDate: json['enrl_date'] ?? '',
      enrlNum: json['enrl_no'] ?? '',
      mobile1: json['mobile1'] ?? '',
      mobile2: json['mobile2'] ?? '',
      email: json['email'] ?? '',
      offAdd1: json['office_add1'] ?? '',
      offAdd2: json['office_add2'] ?? '',
      offAdd3: json['office_add3'] ?? '',
      resAdd1: json['res_add1'] ?? '',
      resAdd2: json['res_add2'] ?? '',
      resAdd3: json['res_add3'] ?? '',
      memNo: json['mem_code'] ?? '',
      offTel: json['office_tel1'],
      resTel: json['res_tel1'],
      pwd: json['password'],
    );
  }
}
