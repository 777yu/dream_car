class aaa {
  String origin;

  aaa({this.origin});

  aaa.fromJson(Map<String, dynamic> json) {
    origin = json['origin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['origin'] = this.origin;
    return data;
  }
}