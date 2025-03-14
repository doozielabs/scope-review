import 'package:inspektify_report/data/models/enum_types.dart';
import 'package:inspektify_report/utils/helpers/general_helper.dart';

class Comment {
  late String? id;
  late String comment;
  late CommentType? type;
  late List<String> images;
  late String level;
  late String location;
  late int? serverTimestamp;
  late int? lastModified;
  late String? uid;

  Comment({
    this.id,
    this.uid,
    this.serverTimestamp,
    this.lastModified,
    this.type,
    this.comment = "",
    this.location = "",
    this.level = "None",
  }) : images = [];

  Comment.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    uid = json["uid"];
    serverTimestamp = json['serverTimestamp'] ?? 0;
    lastModified = json['lastModified'] ?? 0;
    type = GeneralHelper.getType(
      CommentType.values,
      "CommentType",
      json["status"] ?? "",
    );
  /*  level = GeneralHelper.getType(
      CommentLevel.values,
      "CommentLevel",
      json["level"] ?? "",
    );*/
    level = json["level"]??"";
    location = json["location"] ?? "";
    comment = json["description"] ?? "";
    images = List<String>.from(json["commentPhotos"] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["uid"] = uid;
    data['serverTimestamp'] = serverTimestamp;
    data['lastModified'] = lastModified;
    data["location"] = location;
    data["description"] = comment;
    data["level"] = GeneralHelper.typeValue(level);
    data["status"] = GeneralHelper.typeValue(type);
    data["commentPhotos"] = images;
    return data;
  }

  static List<Comment> fromListJson(List list) =>
      list.map((section) => Comment.fromJson(section)).toList();
}
