import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/inspection_report.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class PDFReport extends StatefulWidget {
  final bool showDialogue;
  final dynamic inspection;
  final List media;
  final Function(String url)? printCallBack;
  const PDFReport(
      {Key? key,
      required this.showDialogue,
      this.inspection,
      required this.media,
      this.printCallBack})
      : super(key: key);

  @override
  State<PDFReport> createState() => _PDFReportState();
}

class _PDFReportState extends State<PDFReport> {
  InspectionModel inspection = InspectionModel();
  bool isLoading = false;
  List<ImageShape> media = [];
  @override
  void initState() {
    Future.delayed(const Duration(), () async {
      setState(() => isLoading = true);
      inspection = InspectionModel.fromJson(jsonDecode(widget.inspection));
      for (var image in widget.media) {
        media.add(ImageShape.fromJson(image));
      }
      if (!kIsWeb) {
        documentDirectory = (await getApplicationDocumentsDirectory()).path;
      }
      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
    var inspectionID = Uri.base.pathSegments;
    var concatenate = inspectionID.join("");
      return Sizer(
        builder: ((context, orientation, deviceType) => MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Inspektify Report',
              initialRoute : "/$concatenate",
              routes: <String, WidgetBuilder> {
                  "/$concatenate" : (context) =>  isLoading ? const CupertinoActivityIndicator(
                      color: ProjectColors.firefly)
                      : inspection.template == null
                      ? const CupertinoActivityIndicator(
                          color: ProjectColors.firefly)
                      : InspectionReportScreen(
                          inspection: inspection,
                          media: media,
                          showDialogue: widget.showDialogue,
                          printCallBack: widget.printCallBack,
                        ),

              },
            )));
    } else {
      return Sizer(
        builder: ((context, orientation, deviceType) => MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Inspektify Report',
              home: isLoading
                  ? const CupertinoActivityIndicator(
                      color: ProjectColors.firefly)
                  : inspection.template == null
                      ? const CupertinoActivityIndicator(
                          color: ProjectColors.firefly)
                      : InspectionReportScreen(
                          inspection: inspection,
                          media: media,
                          showDialogue: widget.showDialogue,
                        ),
            )));
    }
    
  }
}
