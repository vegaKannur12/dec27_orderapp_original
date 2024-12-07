class ProductCompanymodel {
  String? comid;
  String? comanme;

  ProductCompanymodel({this.comid, this.comanme});

  ProductCompanymodel.fromJson(Map<String, dynamic> json) {
    comid = json['comid'].toString().trimLeft();
    comanme = json['comanme'].toString().trimLeft();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comid'] = this.comid;
    data['comanme'] = this.comanme;
    return data;
  }
}
