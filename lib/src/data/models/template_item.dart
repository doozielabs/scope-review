import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/item_trail.dart';
import 'package:pdf_report_scope/src/data/models/template_item_default_options.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class TemplateItem {
  late String? id;
  late String? label;
  late dynamic value;
  late bool completed;
  late List<String> images;
  late List options;
  late TemplateItemType? type;
  late List<Comment> comments;
  late List<TemplateItemDefaultOption> defaultOptions;
  late bool allowMultipleSelection;
  late bool visibility;
  late String condition;
  late List<String> conditionOptions;
  late bool prohibitConditionRating;
  late TemplateItemDefaultOption? defaultOption;
  late int? serverTimestamp;
  late int? lastModified;
  late String? uid;
  late Map<String, ItemTrail>? itemTrail;

  TemplateItem({
    this.id,
    this.uid,
    this.serverTimestamp,
    this.lastModified,
    this.type,
    this.label,
    this.value,
    this.defaultOption,
    this.condition = "",
    this.options = const [],
    this.defaultOptions = const [],
    this.conditionOptions = const [],
    this.completed = false,
    this.visibility = true,
    this.allowMultipleSelection = false,
    this.prohibitConditionRating = false,
    this.itemTrail,
  })  : comments = [],
        images = [];

  TemplateItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    uid = json["uid"];
    serverTimestamp = json['serverTimestamp'] ?? 0;
    lastModified = json['lastModified'] ?? 0;
    label = json["itemLabel"];
    value = json["itemValue"];
    condition = json["condition"] ?? "";
    options = json["itemOptions"] ?? [];
    completed = json["completed"] ?? false;
    visibility = json["visibility"] ?? true;
    images = List<String>.from(json["images"] ?? []);
    comments = Comment.fromListJson(json["comments"] ?? []);
    allowMultipleSelection = json["allowMultipleSelection"] ?? false;
    prohibitConditionRating = json["prohibitConditionRating"] ?? false;
    conditionOptions = ((json["conditionOptions"] ?? []) as List).toStringList;
    itemTrail = (json["itemTrail"] == null)
        ? null
        : Map.from(json["itemTrail"]).map((k, v) {
            if (!(v is ItemTrail)) {
              return MapEntry<String, ItemTrail>(k, ItemTrail.fromJson(v));
            }
            return MapEntry<String, ItemTrail>(k, v);
          });
    defaultOption = json["defaultOption"] == null
        ? null
        : TemplateItemDefaultOption.fromJson(json["defaultOption"]);
    defaultOptions = [];
    //repsonse need to be change from server
    // TemplateItemDefaultOption.fromListJson(json["defaultOptions"] ?? []);
    type = GeneralHelper.getType(
      TemplateItemType.values,
      "TemplateItemType",
      json["itemType"],
    );
    if (type.isPhoto) {
      value = List<String>.from(value is List ? json["itemValue"] : []);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['serverTimestamp'] = serverTimestamp;
    data['lastModified'] = lastModified;
    data["itemLabel"] = label;
    data["itemValue"] = value;
    data["itemOptions"] = options;
    data["completed"] = completed;
    data["condition"] = condition;
    data["visibility"] = visibility;
    data["defaultOptions"] = defaultOptions;
    data["conditionOptions"] = conditionOptions;
    data["defaultOption"] = defaultOption?.toJson();
    data["itemType"] = GeneralHelper.typeValue(type);
    data["allowMultipleSelection"] = allowMultipleSelection;
    data["prohibitConditionRating"] = prohibitConditionRating;
    data["images"] = images;
    data["itemTrail"] = itemTrail;
    data["comments"] = List.generate(
      comments.length,
      (index) => comments[index].toJson(),
    );
    data["defaultOptions"] = List.generate(
      defaultOptions.length,
      (index) => defaultOptions[index].toJson(),
    );
    return data;
  }

  static List<TemplateItem> fromListJson(List list) =>
      list.map((section) => TemplateItem.fromJson(section)).toList();
}
