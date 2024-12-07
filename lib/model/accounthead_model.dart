class AccountHead {
  String? code;
  String? hname;
  String? gtype;
  String? ad1;
  String? ad2;
  String? ad3;
  String? aid;
  String? ph;
  String? ba;
  String? ri;
  String? rc;
  String? ht;
  String? mo;
  String? gst;
  String? ac;
  String? cag;

  AccountHead(
      {this.code,
      this.hname,
      this.gtype,
      this.ad1,
      this.ad2,
      this.ad3,
      this.aid,
      this.ph,
      this.ba,
      this.ri,
      this.rc,
      this.ht,
      this.mo,
      this.gst,
      this.ac,
      this.cag});

  AccountHead.fromJson(Map<String, dynamic> json) {
    code = json['code'].toString().trim();
    hname = json['hname'].toString().trim();
    gtype = json['gtype'].toString().trim();
    ad1 = json['ad1'].toString().trim();
    ad2 = json['ad2'].toString().trim();
    ad3 = json['ad3'].toString().trim();
    aid = json['area_id'].toString().trim();
    ph = json['ph'].toString().trim();
    ba = json['ba'].toString().trim();
    ri = json['ri'].toString().trim();
    rc = json['rc'].toString().trim();
    ht = json['ht'].toString().trim();
    mo = json['mo'].toString().trim();
    gst = json['gst'].toString().trim();
    ac = json['ac'].toString().trim();
    cag = json['cag'].toString().trim();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['hname'] = this.hname;
    data['gtype'] = this.gtype;
    data['ad1'] = this.ad1;
    data['ad2'] = this.ad2;
    data['ad3'] = this.ad3;
    data['area_id'] = this.aid;
    data['ph'] = this.ph;
    data['ba'] = this.ba;
    data['ri'] = this.ri;
    data['rc'] = this.rc;
    data['ht'] = this.ht;
    data['mo'] = this.mo;
    data['gst'] = this.gst;
    data['ac'] = this.ac;
    data['cag'] = this.cag;
    return data;
  }
}
