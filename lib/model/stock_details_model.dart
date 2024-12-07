class StockDetails {
  String? ppid;
  String? pstock;

  StockDetails({this.ppid, this.pstock});

  StockDetails.fromJson(Map<String, dynamic> json) {
    ppid = json['bid'].toString().trimLeft();
    pstock = json['stock'].toString().trimLeft();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bid'] = this.ppid;
    data['stock'] = this.pstock;
    return data;
  }
}