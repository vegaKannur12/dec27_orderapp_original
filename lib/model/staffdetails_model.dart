class StaffDetails {
  String? sid;
  String? sname;
  String? unme;
  String? pwd;
  String? area;
  int? track;
  StaffDetails(
      {this.sid, this.sname, this.unme, this.pwd, this.area, this.track});

  StaffDetails.fromJson(Map<String, dynamic> json) {
    sid = json['SID'];
    sname = json['SNAME'];
    unme = json['UNAME'];
    pwd = json['PWD'].toString().trimLeft();
    area = json['AREA'];
    track = json['TRACK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SID'] = this.sid;
    data['SNAME'] = this.sname;
    data['UNAME'] = this.unme;
    data['PWD'] = this.pwd;
    data['AREA'] = this.area;
    data['TRACK'] = this.track;
    return data;
  }
}
