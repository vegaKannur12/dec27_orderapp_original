class ProductsCategoryModel {
  String? cid;
  String? canme;

  ProductsCategoryModel({this.cid, this.canme});

  ProductsCategoryModel.fromJson(Map<String, dynamic> json) {
    cid = json['cid'].toString().trimLeft();
    canme = json['canme'].trimLeft();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['canme'] = this.canme;
    return data;
  }
}