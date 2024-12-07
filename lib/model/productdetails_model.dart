class ProductDetails {
  String? code;
  int? pid;
  String? ean;
  String? item;
  String? unit;
  String? categoryId;
  String? companyId;
  String? stock;
  String? hsn;
  String? tax;
  String? prate;
  String? mrp;
  String? cost;
  String? rate1;
  String? rate2;
  String? rate3;
  String? rate4;
  String? priceFlag;

  ProductDetails(
      {this.code,
      this.pid,
      this.ean,
      this.item,
      this.unit,
      this.categoryId,
      this.companyId,
      this.stock,
      this.hsn,
      this.tax,
      this.prate,
      this.mrp,
      this.cost,
      this.rate1,
      this.rate2,
      this.rate3,
      this.rate4,
      this.priceFlag});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'].toString().trimLeft();
    pid = json['pid'];
    ean = json['ean'].toString().trimLeft();
    item = json['item'].toString().trimLeft();
    unit = json['unit'].toString().trimLeft();
    categoryId = json['category_id'].toString().trimLeft();
    companyId = json['company_id'].toString().trimLeft();
    stock = json['stock'].toString().trimLeft();
    hsn = json['hsn'].toString().trimLeft();
    tax = json['tax'].toString().trimLeft();
    prate = json['prate'].toString().trimLeft();
    mrp = json['mrp'].toString().trimLeft();
    cost = json['cost'].toString().trimLeft();
    rate1 = json['rate1'].toString().trimLeft();
    rate2 = json['rate2'].toString().trimLeft();
    rate3 = json['rate3'].toString().trimLeft();
    rate4 = json['rate4'].toString().trimLeft();
    priceFlag = json['price_flag'].toString().trimLeft();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['pid'] = this.pid;
    data['ean'] = this.ean;
    data['item'] = this.item;
    data['unit'] = this.unit;
    data['category_id'] = this.categoryId;
    data['company_id'] = this.companyId;
    data['stock'] = this.stock;
    data['hsn'] = this.hsn;
    data['tax'] = this.tax;
    data['prate'] = this.prate;
    data['mrp'] = this.mrp;
    data['cost'] = this.cost;
    data['rate1'] = this.rate1;
    data['rate2'] = this.rate2;
    data['rate3'] = this.rate3;
    data['rate4'] = this.rate4;
    data['price_flag'] = this.priceFlag;
    return data;
  }
}