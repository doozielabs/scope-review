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
     inspectionModel.template!.sections =  [
      TemplateSection(name: "Information", uid: '00001'),
      TemplateSection(name: "Report Summary",  uid: '00002' ),
      ...inspectionModel.template!.sections
    ];

    for (var sectionKeys in inspectionModel.template!.sections) {
      if (itemKeys[sectionKeys.uid] == null) {
        itemKeys[sectionKeys.uid!] = GlobalKey();
      }
      for (var subSectionKeys in sectionKeys.subSections) {
        if (itemKeys[subSectionKeys.uid] == null) {
          itemKeys[subSectionKeys.uid!] = GlobalKey();
        }
      }
    }
    
    if (_showDialog && inspectionModel.template!.sections.isNotEmpty) {
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
