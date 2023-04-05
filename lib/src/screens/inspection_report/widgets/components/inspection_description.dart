import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/constants.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/primary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/sub_heading_of_condition_terms.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/sub_heading_of_inspection_description.dart';

import '../../../../utils/helpers/general_helper.dart';

class InspectionDescription extends StatelessWidget {
  final Inspection inspection;
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
              SubHeadingOfInspectionDescritpion(
                primaryText: "${inspection.template?.preparedForDescription}",
                secondryText: 'Anwar',
              ),
              const SizedBox(height: 10),
              SubHeadingOfInspectionDescritpion(
                primaryText: "${inspection.template?.inspectionDateAppearance}",
                secondryText: GeneralHelper.getInspectionDateTimeFormat(
                    inspection.startDate),
              ),
              const SizedBox(height: 10),
              //Static Text for Client
              Text("${inspection.template?.reportHeader.replaceAll('	', '\n')}",
                  style: TextStyle(fontSize: 16)),
              // RichText(
              //   text: TextSpan(
              //     style: TextStyle(
              //         color: ProjectColors.firefly,
              //         fontSize: 16.0,
              //         fontFamily: fontFamilyJostRegular),
              //     children: [
              //       TextSpan(
              //           text:
              //               "${inspection.template?.reportHeader}", //'Thank you for the opportunity to conduct a home inspection of the property listed above. We understand that the function of this report is to assist you in understanding the condition of the property to assist in making an informed purchase decision\n\n',
              //           style: TextStyle(fontSize: 16)),
              //       // TextSpan(
              //       //     text:
              //       //         'The report contains a review of components in the following basic categories: site, exterior, roofing, structure, electrical, HVAC, plumbing, and interior. Additional categories may or may not be included. The report is designed to be easy to read and comprehend however it is important to read the entire report to obtain a full understanding of the scope, limitations and exclusions of the inspection.\n\n',
              //       //     style: TextStyle(fontSize: 16)),
              //       // TextSpan(
              //       //     text:
              //       //         'In addition to the checklist items of the report there are several comments which are meant to help you further understand certain conditions observed. These are easy to find by looking for their icons along the left side margin. Comments with the blue icon are primarily informational and comments with the orange icon are also displayed on the summary. Please read them all.\n',
              //       //     style: TextStyle(fontSize: 16)),
              //     ],
              //   ),
              // ),
              // Text(
              //   "definition of condition terms".toUpperCase(),
              //   style: primaryHeadingTextStyle.copyWith(
              //       fontFamily: fontFamilyJostRegular),
              // ),
              // ...List.generate(definationText.length, (index) {
              //   String title = definationText.keys.elementAt(index);
              //   String value = definationText[title]!;
              //   return Padding(
              //     padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              //     child: SubHeadingOfConditionTerms(
              //         primaryText: title, secondryText: value),
              //   );
              // })
            ],
          ),
        ),
      ),
    );
  }
}
