import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/primary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/sub_heading_of_inspection_description.dart';

import '../../../../utils/helpers/general_helper.dart';

class InspectionDescription extends StatelessWidget {
  final InspectionModel inspection;
  const InspectionDescription({Key? key, required this.inspection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: ProjectColors.aliceBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading Text
              const PrimaryHeadingTextWithBackground(
                backgroundColor: ProjectColors.primary,
                headingText: 'inspection description',
              ),
              const SizedBox(height: 10),
              //Sub headings
              // SubHeadingOfInspectionDescritpion(
              //   primaryText: "Prepared By:",
              //   secondryText: inspection.user!.firstname! +
              //       " " +
              //       (inspection.user?.lastname ?? ""),
              // ),
              const SizedBox(height: 10),
              SubHeadingOfInspectionDescritpion(
                primaryText: "${inspection.template?.preparedForDescription}",
                secondryText:
                    "${inspection.client!.firstname} ${inspection.client?.lastname ?? ""}",
              ),
              const SizedBox(height: 10),
              SubHeadingOfInspectionDescritpion(
                primaryText: "${inspection.template?.inspectionDateAppearance}",
                secondryText: GeneralHelper.getInspectionDateTimeFormat(
                    inspection.startDate),
              ),
              const SizedBox(height: 10),
              Text("${inspection.template?.reportHeader.replaceAll('	', '\n')}",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
