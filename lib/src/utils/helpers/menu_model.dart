import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/pdf_report_scope.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/user_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_eyeshot.dart';

import 'general_helper.dart';

class ShowMenuDialogue {
  final bool _showDialog;

  ShowMenuDialogue(this._showDialog);

  void showMenu(BuildContext context, dynamic inspection,
      dynamic selectedTemplate, dynamic templates, dynamic user,
      {Function? sharepdf, Function? needUpgrade}) {
    List<Template> templatesData = [];
    InspectionModel inspectionModel =
        InspectionModel.fromJson(jsonDecode(inspection));
    Template selectedTemplateModel =
        Template.fromJson(jsonDecode(selectedTemplate));
    User userData = User.fromJson(jsonDecode(user));
    for (var template in templates) {
      templatesData.add(Template.fromJson(jsonDecode(template)));
    }
    selectedTemplate = GeneralHelper.setTrailItem(
        templatesData, selectedTemplateModel, inspectionModel, userData);

    if (_showDialog) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SectionEyeShotForMobileAndTablet(
              selectedTemplate: selectedTemplate,
              inspection: inspectionModel,
              sharePdf: sharepdf,
              needUpgrade: needUpgrade,
            );
          });
    }
  }
}
