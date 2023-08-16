import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/pdf_report_scope.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_eyeshot.dart';

class ShowMenuDialogue {
  final bool _showDialog;

  ShowMenuDialogue(this._showDialog);

  void showMenu(BuildContext context, dynamic inspection,
      {Function? sharepdf}) {
    InspectionModel inspectionModel =
        InspectionModel.fromJson(jsonDecode(inspection));
    if (_showDialog) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SectionEyeShotForMobileAndTablet(
              inspection: inspectionModel,
              sharePdf: sharepdf,
            );
          });
    }
  }
}
