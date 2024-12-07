import 'dart:typed_data';

class RegistrationData2 {
  String? cid;
  int? ctype;
  int? hoid;
  String? cnme;
  String? ad1;
  String? ad2;
  String? ad3;
  String? plc;
  String? gst;
  String? ccode;
  int? scode;
  String? os;
  String? logintype;
  String? conip;
  int? conport;
  String? conuser;
  String? conpass;
  String? condb;

  RegistrationData2(
      {this.cid,
      this.ctype,
      this.hoid,
      this.cnme,
      this.ad1,
      this.ad2,
      this.ad3,
      this.plc,
      this.gst,
      this.ccode,
      this.scode,
      this.os,
      this.logintype,
      this.conip,
      this.conport,
      this.conuser,
      this.conpass,
      this.condb});
  RegistrationData2.fromJson(Map<String, dynamic> json) {
    cid = json['COMPANY_ID'];
    ctype = json['COMPNAY_TYPE'];
    hoid = json["HEADOFFICE_ID"];
    cnme = json["COMPNAY_NAME"];
    ad1 = json["ADDRESS1"];
    ad2 = json["ADDRESS2"];
    ad3 = json["ADDRESS3"];
    plc = json["PLACE"];
    gst = json["GSTIN"];
    ccode = json["COUNTRY_CODE"];
    scode = json["STATE_CODE"];
    os = json['SERIES'];
    logintype = json['LOGIN_TYPE'];
    conip = json['CON_IP'].toString().trim();
    conport = json['CON_PORT'];
    conuser = json['CON_USER'].toString().trim();
    conpass = json['CON_PASS'].toString().trim();
    condb = json['CON_DB'].toString().trim();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COMPANY_ID'] = this.cid;
    data['COMPNAY_TYPE'] = this.ctype;
    data["HEADOFFICE_ID"] = this.hoid;
    data["COMPNAY_NAME"] = this.cnme;
    data["ADDRESS1"] = this.ad1;
    data["ADDRESS2"] = this.ad2;
    data["ADDRESS3"] = this.ad3;
    data["PLACE"] = this.plc;
    data["GSTIN"] = this.gst;
    data["COUNTRY_CODE"] = this.ccode;
    data["STATE_CODE"] = this.scode;
    data['SERIES'] = this.os;
    data['LOGIN_TYPE'] = this.logintype;
    data['CON_IP'] = this.conip;
    data['CON_PORT'] = this.conport;
    data['CON_USER'] = this.conuser;
    data['CON_PASS'] = this.conpass;
    data['CON_DB'] = this.condb;
    return data;
  }
}
