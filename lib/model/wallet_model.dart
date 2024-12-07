class WalletModal {
  String? waid;
  String? wanme;

  WalletModal({this.waid, this.wanme});

  WalletModal.fromJson(Map<String, dynamic> json) {
    waid = json['wallet_id'].toString().trimLeft();
    wanme = json['wallet_name'].toString().trimLeft();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_id'] = this.waid;
    data['wallet_name'] = this.wanme;
    return data;
  }
}