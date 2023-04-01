import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/data/models/template_subsection.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class InspectinCleintWithAgreement {
  String id;
  String name;
  bool selected;

  InspectinCleintWithAgreement({
    this.id = "",
    this.name = "",
    this.selected = false,
  });
}

class TemplateAbout {
  Comment? comment;
  TemplateItem? item;
  TemplateSection? section;
  TemplateSubSection? subSection;

  TemplateAbout({this.comment, this.item, this.section, this.subSection});
}

class TemplateConditionOptions {
  final int? id;
  final String value;

  TemplateConditionOptions({this.value = "", this.id});
}

class TemplateConditionRatingOptions {
  late List<String> conditionalOptions;
  late bool enableConditionRatings;
  late bool requireConditionRatingsForItemsToBeConsideredComplete;

  TemplateConditionRatingOptions({
    this.conditionalOptions = const [],
    this.enableConditionRatings = false,
    this.requireConditionRatingsForItemsToBeConsideredComplete = false,
  });

  TemplateConditionRatingOptions.fromJson(Map<String, dynamic> json) {
    conditionalOptions = (json["conditionalOptions"] as List).toStringList;
    enableConditionRatings = json["enableConditionRatings"];
    requireConditionRatingsForItemsToBeConsideredComplete =
        json["requireConditionRatingsForItemsToBeConsideredComplete"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["conditionalOptions"] = conditionalOptions;
    data["enableConditionRatings"] = enableConditionRatings;
    data["requireConditionRatingsForItemsToBeConsideredComplete"] =
        requireConditionRatingsForItemsToBeConsideredComplete;
    return data;
  }
}

class TemplateReportSummaryOptions {
  late bool endOfReport;

  late bool beginningOfReport;

  late bool noReportSummary;

  TemplateReportSummaryOptions({
    this.endOfReport = false,
    this.beginningOfReport = false,
    this.noReportSummary = false,
  });

  TemplateReportSummaryOptions.fromJson(Map<String, dynamic> json) {
    endOfReport = json["endOfReport"];
    beginningOfReport = json["beginningOfReport"];
    noReportSummary = json["noReportSummary"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["endOfReport"] = endOfReport;
    data["noReportSummary"] = noReportSummary;
    data["beginningOfReport"] = beginningOfReport;
    return data;
  }
}

class Sheep {
  String id;
  SheepType type;
  SheepMember member;

  Sheep({
    required this.id,
    this.type = SheepType.none,
    this.member = SheepMember.inspection,
  });
}
