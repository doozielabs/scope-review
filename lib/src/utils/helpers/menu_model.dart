import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/pdf_report_scope.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_eyeshot.dart';

class ShowMenuDialogue {
  final bool _showDialog;

  ShowMenuDialogue(this._showDialog);

  void showMenu(BuildContext context, dynamic inspection) {
    InspectionModel inspectionModel =
        InspectionModel.fromJson(jsonDecode(inspection));
    print("inspectionModel:${inspectionModel.name}");
    if (_showDialog) {
      // Show the dialog
      showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return SectionEyeShotForMobileAndTablet(
                inspection: inspectionModel);
          });
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text("Alert Dialog"),
      //       content: Text("Dialog Content"),
      //       actions: [
      //         TextButton(
      //           child: Text("Close"),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         )
      //       ],
      //     );
      //   },
      // );
    }
  }
}