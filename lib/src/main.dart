import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/inspection_report.dart';
import 'package:sizer/sizer.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class PDFReport extends StatelessWidget {
  const PDFReport({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: ((context, orientation, deviceType) => MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Inspektify Report',
              home: const InspectionReportScreen(),
            )));
  }
}
