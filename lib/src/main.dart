import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/user_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/inspection_report.dart';
import 'package:sizer/sizer.dart';

import 'core/constant/typography.dart';

class PDFReport extends StatefulWidget {
  final bool showDialogue;
  final bool? isdownloading;
  final String? pdfStatus;
  final dynamic inspection;
  final dynamic user;
  final dynamic templates;
  final dynamic selectedTemplate;
  final List media;
  final Function? mediaCallBack;
  final Function? printCallBack;
  final Function? downloadCallBack;
  final Function? sharePdf;
  const PDFReport(
      {Key? key,
      required this.showDialogue,
      this.inspection,
      this.isdownloading,
      this.pdfStatus,
      required this.media,
      this.templates,
      this.printCallBack,
      this.mediaCallBack,
      this.downloadCallBack,
      this.sharePdf,
      this.user,
      this.selectedTemplate})
      : super(key: key);

  @override
  State<PDFReport> createState() => _PDFReportState();
}

class _PDFReportState extends State<PDFReport> {
  InspectionModel inspection = InspectionModel();
  User user = User();
  bool isLoading = false;
  bool isok = false;
  bool isdownloading = false;
  String pdfStatus = 'wait';
  String message = "PDF generation in progress... Please be patient.";
  List<ImageShape> media = [];
  List<Template> templates = [];
  Template? selectedTemplate;
  Key widgetKey = Key("${DateTime.now().microsecondsSinceEpoch}");
  @override
  void initState() {
    print("Review package init");
    Future.delayed(Duration.zero, () async {
      setState(() => isLoading = true);
      inspection = InspectionModel.fromJson(jsonDecode(widget.inspection));
      user = User.fromJson(jsonDecode(widget.user));
      updateListOfTemplates();
      getDocumentDirectory();
      setState(() => isLoading = false);
    });
    super.initState();
  }

  getDocumentDirectory() async {
    if (!kIsWeb) {
      documentDirectory = (await getApplicationDocumentsDirectory()).path;
    }
  }

  showPleaseWaitModal() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              Widget okButton = TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  pdfStatus = 'wait';
                },
              );
              if (pdfStatus == 'true' || pdfStatus == 'false') {
                isok = true;
              } else {
                isok = false;
              }
              if (pdfStatus == 'wait') {
                message = "PDF in Progress... Please be patient.";
              } else if (pdfStatus == 'false') {
                message = "Something Went Wrong. Please try again later.";
              } else if (pdfStatus == 'true') {
                message =
                    "PDF Generated. Download will start in a few seconds....";
              }
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isok
                        ? Image.network(
                            imgBaseUrl + generatedPdf,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imgBaseUrl + generationPdf,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(height: 16.0), // Add some spacing
                    Text(
                      message,
                      style: primaryHeadingTextStyle.copyWith(),
                    ),
                    isok ? okButton : const SizedBox(),
                  ],
                ),
              );
            },
          );
        });
  }

  updateListOfTemplates() {
    templates.clear();
    if (widget.selectedTemplate != null) {
      selectedTemplate = Template.fromJson(jsonDecode(widget.selectedTemplate));
    }
    for (var template in widget.templates) {
      templates.add(Template.fromJson(jsonDecode(template)));
    }
    for (var image in widget.media) {
      if (ImageShape.fromJson(image).trashed != true) {
        media.add(ImageShape.fromJson(image));
      }
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    pdfStatus = widget.pdfStatus ?? "wait";
    media.clear();
    print("Package update");
    if (!kIsWeb) {
      widgetKey = Key("${DateTime.now().microsecondsSinceEpoch}");
    }
    updateListOfTemplates();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      isdownloading = widget.isdownloading ?? false;
      pdfStatus = widget.pdfStatus ?? "wait";
      var inspectionID = Uri.base.pathSegments;
      var concatenate = inspectionID.join("");
      return Sizer(
          builder: ((context, orientation, deviceType) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Scope-Report',
                initialRoute: "/$concatenate",
                routes: <String, WidgetBuilder>{
                  "/$concatenate": (context) => isLoading
                      ? const CupertinoActivityIndicator(
                          color: ProjectColors.firefly)
                      : (templates.isEmpty)
                          ? const CupertinoActivityIndicator(
                              color: ProjectColors.firefly)
                          : InspectionReportScreen(
                              inspection: inspection,
                              media: media,
                              isdownloading: isdownloading,
                              pdfStatus: pdfStatus,
                              templates: templates,
                              mediaCallBack: widget.mediaCallBack,
                              showDialogue: widget.showDialogue,
                              printCallBack: widget.printCallBack,
                              downloadCallBack: () {
                                widget.downloadCallBack!.call();
                                showPleaseWaitModal();
                              },
                              sharePdf: widget.sharePdf,
                              user: user,
                            ),
                },
              )));
    } else {
      return Sizer(
          builder: ((context, orientation, deviceType) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Scope-Report',
                home: isLoading
                    ? const CupertinoActivityIndicator(
                        color: ProjectColors.firefly)
                    : (templates.isEmpty && selectedTemplate == null)
                        ? const CupertinoActivityIndicator(
                            color: ProjectColors.firefly)
                        : InspectionReportScreen(
                            key: widgetKey,
                            inspection: inspection,
                            media: media,
                            templates: templates,
                            selectedTemplate: selectedTemplate,
                            showDialogue: widget.showDialogue,
                            sharePdf: widget.sharePdf,
                            user: user,
                          ),
              )));
    }
  }
}
