class SideMenu2 {
  String? menu_index;
  String? menu_name;
  String? first;

  SideMenu2({this.menu_index, this.menu_name, this.first});

  SideMenu2.fromJson(Map<String, dynamic> json) {
    menu_index = json['menu_index'];
    menu_name = json['menu_name'];
    first = json['first'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_index'] = this.menu_index;
    data['menu_name'] = this.menu_name;
    data['first'] = this.first;
    return data;
  }
}
