import 'dart:convert';

PaymentModel paymentModelFromJson(String str) => PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  String code;
  bool status;
  String message;
  Result result;

  PaymentModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    code: json["code"] ?? '',
    status: json["status"] ?? false,
    message: json["message"] ?? '',
    result: Result.fromJson(json["result"] ?? {}),
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
    details: List<Detail>.from(json["details"]?.map((x) => Detail.fromJson(x)) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Detail {
  String? receiptNo;
  String? receiptDate;
  String? memCode;
  String? receiptName;
  String? cB;
  String? bankName;
  String? chqNo;
  String? admFee;
  String? readmFee;
  String? subsAmt;
  String? lenAmt;
  String? elecAmt;
  String? libAmt;
  String? icardAmt;
  String? locRent;
  String? others;
  String? headNo;
  String? totalAmt;
  String? headName;
  String? remark;
  String? createdBy;
  String? courtName;
  dynamic onAc;

  Detail({
    this.receiptNo,
    this.receiptDate,
    this.memCode,
    this.receiptName,
    this.cB,
    this.bankName,
    this.chqNo,
    this.admFee,
    this.readmFee,
    this.subsAmt,
    this.lenAmt,
    this.elecAmt,
    this.libAmt,
    this.icardAmt,
    this.locRent,
    this.others,
    this.headNo,
    this.totalAmt,
    this.headName,
    this.remark,
    this.createdBy,
    this.courtName,
    this.onAc,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    receiptNo: json["receipt_no"] ?? '',
    receiptDate: json["receipt_date"] ?? '',
    memCode: json["mem_code"] ?? '',
    receiptName: json["receipt_name"] ?? '',
    cB: json["c_b"] ?? '',
    bankName: json["bank_name"] ?? '',
    chqNo: json["chq_no"] ?? '',
    admFee: json["adm_fee"] ?? '',
    readmFee: json["readm_fee"] ?? '',
    subsAmt: json["subs_amt"] ?? '',
    lenAmt: json["len_amt"] ?? '',
    elecAmt: json["elec_amt"] ?? '',
    libAmt: json["lib_amt"] ?? '',
    icardAmt: json["icard_amt"] ?? '',
    locRent: json["loc_rent"] ?? '',
    others: json["others"] ?? '',
    headNo: json["head_no"] ?? '',
    totalAmt: json["total_amt"] ?? '',
    headName: json["head_name"] ?? '',
    remark: json["remark"] ?? '',
    createdBy: json["created_by"] ?? '',
    courtName: json["court_name"] ?? '',
    onAc: json["on_ac"],
  );

  Map<String, dynamic> toJson() => {
    "receipt_no": receiptNo,
    "receipt_date": receiptDate,
    "mem_code": memCode,
    "receipt_name": receiptName,
    "c_b": cB,
    "bank_name": bankName,
    "chq_no": chqNo,
    "adm_fee": admFee,
    "readm_fee": readmFee,
    "subs_amt": subsAmt,
    "len_amt": lenAmt,
    "elec_amt": elecAmt,
    "lib_amt": libAmt,
    "icard_amt": icardAmt,
    "loc_rent": locRent,
    "others": others,
    "head_no": headNo,
    "total_amt": totalAmt,
    "head_name": headName,
    "remark": remark,
    "created_by": createdBy,
    "court_name": courtName,
    "on_ac": onAc,
  };
}
