import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';

class TemplateSubSection {
  late String? id;
  late String? name;
  late String? header;
  late String? footer;
  late List<Comment> comments;
  late List<TemplateItem> items;
  late bool? visibility;
  late List<String> images;
  late int? serverTimestamp;
  late int? lastModified;
  late String? uid;

  TemplateSubSection({
    this.id,
    this.uid,
    this.serverTimestamp,
    this.lastModified,
    this.name,
    this.header,
    this.footer,
    this.visibility = true,
  })  : images = [],
        items = [],
        comments = [];

  TemplateSubSection.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    uid = json["uid"];
    serverTimestamp = json['serverTimestamp'] ?? 0;
    lastModified = json['lastModified'] ?? 0;
    header = json["header"] ?? '' ;
    footer = json["footer"] ?? '';
    name = json["sectionLabel"];
    visibility = json["visibility"] ?? true;
    items = TemplateItem.fromListJson(json["items"]);
    comments = Comment.fromListJson(json["comments"]);
    images = List<String>.from(json["images"] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['serverTimestamp'] = serverTimestamp;
    data['lastModified'] = lastModified;
    data["header"] = header;
    data["footer"] = footer;
    data["sectionLabel"] = name;
    data["visibility"] = visibility;
    data["items"] = List.generate(
      items.length,
      (index) => items[index].toJson(),
    );
    data["comments"] = List.generate(
      comments.length,
      (index) => comments[index].toJson(),
    );
    data["images"] = images;
    return data;
  }

  static List<TemplateSubSection> fromListJson(List list) =>
      list.map((section) => TemplateSubSection.fromJson(section)).toList();
}
