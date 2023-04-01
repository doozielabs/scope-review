import 'package:pdf_report_scope/src/data/models/general_models.dart';

class TemplateReportSummary {
  late String summaryHeader;

  late String summaryFooter;

  late bool includeImagesInTheReportSummary;

  late TemplateReportSummaryOptions? options;

  late bool includeOriginalCommentNumberInTheReportSummary;

  late String? id;

  late int? serverTimestamp;

  late int? lastModified;

  TemplateReportSummary({
    this.id,
    this.serverTimestamp,
    this.lastModified,
    this.options,
    this.summaryHeader = "",
    this.summaryFooter = "",
    this.includeImagesInTheReportSummary = false,
    this.includeOriginalCommentNumberInTheReportSummary = false,
  });

  TemplateReportSummary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serverTimestamp = json['serverTimestamp'] ?? 0;
    lastModified = json['lastModified'] ?? 0;
    summaryHeader = json["summaryHeader"];
    summaryFooter = json["summaryFooter"];
    options = TemplateReportSummaryOptions.fromJson(json["options"]);
    includeImagesInTheReportSummary = json["includeImagesInTheReportSummary"];
    includeOriginalCommentNumberInTheReportSummary =
        json["includeOriginalCommentNumberInTheReportSummary"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["serverTimestamp"] = serverTimestamp;
    data["lastModified"] = lastModified;
    data["summaryHeader"] = summaryHeader;
    data["summaryFooter"] = summaryFooter;
    data["options"] = options!.toJson();
    data["includeImagesInTheReportSummary"] = includeImagesInTheReportSummary;
    data["includeOriginalCommentNumberInTheReportSummary"] =
        includeOriginalCommentNumberInTheReportSummary;
    return data;
  }
}
