import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/general_models.dart';
import 'package:pdf_report_scope/src/data/models/template_report_summary.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class Template {
  late String? id;
  late String name;
  late int? sortNo;
  late String pageFooter;
  late bool baseTemplate;
  late String description;
  late String reportHeader;
  late String reportFooter;
  late int? templateStatus;
  late bool adminPublished;
  late bool defaultTemplate;
  late bool tableOfContents;
  late String printedReportTitle;
  late String preparedForDescription;
  late String inspectorAppearanceName;
  late bool scaleThePropertyPhotoLarge;
  late String propertyAddressDescription;
  late String? inspectionDateAppearance;
  late bool startEachSectionOnNewPageInPdf;
  late List<TemplateSection> sections;
  late bool verticallyCenterTitlePageContent;
  late TemplateReportSummary? reportSummaryOptions;
  late TemplateConditionRatingOptions? conditionRatingOptions;
  late int? boxKey;
  late bool listWithUserTemplates;
  late int? serverTimestamp;
  late int? lastModified;
  late String? uid;

  Template({
    this.boxKey,
    this.id = "",
    this.uid,
    this.serverTimestamp,
    this.lastModified,
    this.sortNo = 0,
    this.templateStatus = 0,
    this.reportSummaryOptions,
    this.conditionRatingOptions,
    this.inspectionDateAppearance = "",
    this.name = "",
    this.pageFooter = "",
    this.description = "",
    this.reportFooter = "",
    this.reportHeader = "",
    this.printedReportTitle = "",
    this.preparedForDescription = "",
    this.inspectorAppearanceName = "",
    this.propertyAddressDescription = "",
    this.baseTemplate = false,
    this.adminPublished = false,
    this.listWithUserTemplates = false,
    this.defaultTemplate = false,
    this.tableOfContents = false,
    this.scaleThePropertyPhotoLarge = false,
    this.startEachSectionOnNewPageInPdf = false,
    this.verticallyCenterTitlePageContent = false,
  }) : sections = [];

  Template.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    uid = json["uid"];
    serverTimestamp = json['serverTimestamp'] ?? 0;
    lastModified = json['lastModified'] ?? 0;
    boxKey = json["boxKey"];
    sortNo = json["sortNo"];
    name = json["templateName"];
    pageFooter = json["pageFooter"];
    reportHeader = json["reportHeader"];
    reportFooter = json["reportFooter"];
    baseTemplate = json["baseTemplate"];
    templateStatus = json["templateStatus"];
    adminPublished = json["adminPublished"];
    listWithUserTemplates = json["listWithUserTemplates"] ?? false;
    defaultTemplate = json["defaultTemplate"];
    description = json["templateDescription"];
    tableOfContents = json["showTableOfContents"];
    printedReportTitle = json["printedReportTitle"];
    preparedForDescription = json["preparedForDescription"];
    inspectorAppearanceName = json["inspectorAppearanceName"];
    inspectionDateAppearance = json["inspectionDateAppearance"];
    scaleThePropertyPhotoLarge = json["scaleThePropertyPhotoLarge"];
    propertyAddressDescription = json["propertyAddressDescription"];
    startEachSectionOnNewPageInPdf = json["startEachSectionOnNewPageInPdf"];
    verticallyCenterTitlePageContent = json["verticallyCenterTitlePageContent"];
    sections = TemplateSection.fromListJson(json["templateContent"]);
    reportSummaryOptions =
        TemplateReportSummary.fromJson(json["reportSummaryOptions"]);
    conditionRatingOptions = json["conditionRatingOptions"] == null
        ? TemplateConditionRatingOptions()
        : TemplateConditionRatingOptions.fromJson(
            json["conditionRatingOptions"]);
  }

  static List<Template> fromListJson(List list) =>
      list.map((section) => Template.fromJson(section)).toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["uid"] = uid;
    data['serverTimestamp'] = serverTimestamp;
    data['lastModified'] = lastModified;
    data["boxKey"] = boxKey;
    data["sortNo"] = sortNo;
    data["templateName"] = name;
    data["pageFooter"] = pageFooter;
    data["reportHeader"] = reportHeader;
    data["reportFooter"] = reportFooter;
    data["baseTemplate"] = baseTemplate;
    data["templateStatus"] = templateStatus;
    data["adminPublished"] = adminPublished;
    data["listWithUserTemplates"] = listWithUserTemplates;
    data["defaultTemplate"] = defaultTemplate;
    data["templateDescription"] = description;
    data["showTableOfContents"] = tableOfContents;
    data["printedReportTitle"] = printedReportTitle;
    data["preparedForDescription"] = preparedForDescription;
    data["inspectorAppearanceName"] = inspectorAppearanceName;
    data["inspectionDateAppearance"] = inspectionDateAppearance;
    data["scaleThePropertyPhotoLarge"] = scaleThePropertyPhotoLarge;
    data["propertyAddressDescription"] = propertyAddressDescription;
    data["startEachSectionOnNewPageInPdf"] = startEachSectionOnNewPageInPdf;
    data["verticallyCenterTitlePageContent"] = verticallyCenterTitlePageContent;
    data["templateContent"] = List.generate(
      sections.length,
      (index) => sections[index].toJson(),
    );
    data["reportSummaryOptions"] = reportSummaryOptions!.toJson();
    data["conditionRatingOptions"] = conditionRatingOptions!.toJson();
    return data;
  }

  String commentTitle(Comment comment) {
    var _data = about(comment.id ?? "");
    return "Comment ( ${[
      _data.section?.name,
      _data.subSection?.name,
      _data.item?.label,
    ].where((_) {
      return (_.isNull ? "" : _)!.isNotEmpty;
    }).join(" - ")} )";
  }
}
