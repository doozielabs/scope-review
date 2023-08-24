class ItemTrail {
  late String uid;
  late String? ref;
  late String? path;

  ItemTrail({
    required this.uid,
    this.ref,
    this.path,
  });

  ItemTrail.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    path = json["path"] ?? "";
    ref = json["ref"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['path'] = this.path;
    data['ref'] = this.ref;
    return data;
  }
}
