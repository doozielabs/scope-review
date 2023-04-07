import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/providers/inspection_provider.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/inspection_report.dart';
import 'package:sizer/sizer.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class PDFReport extends StatefulWidget {
  final bool showDialogue;
  final dynamic inspection;
  const PDFReport({Key? key, required this.showDialogue, this.inspection})
      : super(key: key);

  @override
  State<PDFReport> createState() => _PDFReportState();
}

class _PDFReportState extends State<PDFReport> {
  InspectionModel? inspection;
  bool isLoading = false;
  List<ImageShape>? media;
  @override
  void initState() {
    Future.delayed(const Duration(), () async {
      setState(() => isLoading = true);
      inspection = await InspectionProvider().getInspection();
      // inspection = InspectionModel.fromJson(widget.inspection);
      print("mainins:${widget.inspection}");
      media = await InspectionProvider().getPhotoByIds(inspection!)
          as List<ImageShape>;
      // print('img si $media');
      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: ((context, orientation, deviceType) => MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Inspektify Report',
              home: isLoading
                  ? const CupertinoActivityIndicator(
                      color: ProjectColors.firefly)
                  : InspectionReportScreen(
                      inspection: inspection!,
                      media: media!,
                      showDialogue: widget.showDialogue,
                    ),
            )));
  }
}
