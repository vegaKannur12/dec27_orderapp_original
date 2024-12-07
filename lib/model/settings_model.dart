class SettingsModel {
  String? setId;
  String? setCode;
  String? setValue;
  String? setType;
  SettingsModel({this.setId, this.setCode, this.setValue, this.setType});
  SettingsModel.fromJson(Map<String, dynamic> json) {
    setId = json['set_id'].toString().trimLeft();
    setCode = json['set_code'].toString().trimLeft();
    setValue = json['set_value'].toString().trimLeft();
    setType = json['set_type'].toString().trimLeft();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['set_id'] = this.setId;
    data['set_code'] = this.setCode;
    data['set_value'] = this.setValue;
    data['set_type'] = this.setType;
    return data;
  }
}
