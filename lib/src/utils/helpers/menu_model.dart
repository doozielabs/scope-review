import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/pdf_report_scope.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_eyeshot.dart';

class ShowMenuDialogue {
  final bool _showDialog;

  ShowMenuDialogue(this._showDialog);

  void showMenu(
      BuildContext context, dynamic inspection, dynamic selectedTemplate,
      {Function? sharepdf, Function? needUpgrade}) {
    InspectionModel inspectionModel =
        InspectionModel.fromJson(jsonDecode(inspection));
    Template selectedTemplateModel =
        Template.fromJson(jsonDecode(selectedTemplate));

    if (_showDialog) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SectionEyeShotForMobileAndTablet(
              selectedTemplate: selectedTemplateModel,
              inspection: inspectionModel,
              sharePdf: sharepdf,
              needUpgrade: needUpgrade,
            );
          });
    }
  }
}
