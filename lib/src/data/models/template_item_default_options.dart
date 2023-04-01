class TemplateItemDefaultOption {
  late String value;

  late String? color;

  late String comment;

  late String? id;

  late int? serverTimestamp;

  late int? lastModified;

  TemplateItemDefaultOption(
      {this.color,
      this.value = "",
      this.comment = "",
      this.id,
      this.serverTimestamp,
      this.lastModified});

  TemplateItemDefaultOption.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    color = json['color'];
    comment = json['comment'];
    id = json['id'];
    serverTimestamp = json['serverTimestamp'] ?? 0;
    lastModified = json['lastModified'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['color'] = color;
    data['comment'] = comment;
    data['id'] = id;
    data['serverTimestamp'] = serverTimestamp;
    data['lastModified'] = lastModified;
    return data;
  }

  static List<TemplateItemDefaultOption> fromListJson(List list) =>
      list.map((option) => TemplateItemDefaultOption.fromJson(option)).toList();
}
