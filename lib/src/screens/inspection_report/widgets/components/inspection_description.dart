import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/user_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/primary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/sub_heading_of_inspection_description.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

import '../../../../utils/helpers/general_helper.dart';

class InspectionDescription extends StatelessWidget {
  final InspectionModel inspection;
  final Template selectedTemplate;
  final User user;
  const InspectionDescription(
      {Key? key,
      required this.inspection,
      required this.user,
      required this.selectedTemplate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool contactDetail = false;
    bool userDetail = false;
    if (inspection.client!.firstname.isNotEmpty ||
        inspection.client!.lastname.isNotEmpty) {
      contactDetail = true;
    }
    if (user.firstname!.isNotEmpty || user.lastname!.isNotEmpty) {
      userDetail = true;
    }

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
              userDetail
                  ? SubHeadingOfInspectionDescritpion(
                      primaryText: selectedTemplate.preparedForDescription,
                      secondryText: inspection.client?.fullName ?? "",
                    )
                  : const Visibility(child: SizedBox()),
              const SizedBox(height: 10),
              contactDetail
                  ? SubHeadingOfInspectionDescritpion(
                      primaryText: selectedTemplate.inspectorAppearanceName,
                      secondryText: user.fullName,
                    )
                  : const Visibility(child: SizedBox()),
              const SizedBox(height: 10),
              SubHeadingOfInspectionDescritpion(
                primaryText: "${selectedTemplate.inspectionDateAppearance}",
                secondryText: GeneralHelper.getInspectionDateTimeFormat(
                    inspection.startDate),
              ),
              const SizedBox(height: 10),
              Text(selectedTemplate.name.unspecified.toUpperCase() + ' SERVICE',
                style: primaryHeadingTextStyle.copyWith(color: ProjectColors.pickledBluewood,),
              ),
              const SizedBox(height: 10),
              // Text("${selectedTemplate.description.replaceAll('	', '\n')}",
              //     style: secondryHeadingTextStyle.copyWith(
              //       color: ProjectColors.pickledBluewood,
              //     )),
              Text(
                  "Thank you for the opportunity to conduct a home inspection of the property listed above. We understand that the function of this report is to assist you in understanding the condition of the property to assist in making an informed purchase decision.",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 10),
              Text(
                  "The report contains a review of components in the following basic categories: site, exterior, roofing, structure, electrical, HVAC, plumbing, and interior. Additional categories may or may not be included. The report is designed to be easy to read and comprehend however it is important to read the entire report to obtain a full understanding of the scope, limitations and exclusions of the inspection.",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 10),
              Text(
                  "In addition to the checklist items of the report there are several comments which are meant to help you further understand certain conditions observed. These are easy to find by looking for their icons along the left side margin. Comments with the blue icon are primarily informational and comments with the orange icon are also displayed on the summary. Please read them all.",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 20),
              Text("DEFINITION OF CONDITION TERMS.",
                  style: secondryHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 10),
              Text("Satisfactory:",
                  style: secondryHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 5),
              Text(
                  "At the time of inspection the component is functional without observed signs of a substantial defect.",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 10),
              Text("Marginal:",
                  style: secondryHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 5),
              Text(
                  "At the time of inspection the component is functioning but is estimated to be nearing end of useful life. Operational maintenance recommended. Replacement anticipated.",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 10),
              Text("Repair or Replace:",
                  style: secondryHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 5),
              Text(
                  "At the time of inspection the component does not function as intended or presents a Safety Hazard. Repair or replacement is recommended.",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 10),
              Text("Further Evaluation:",
                  style: secondryHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 5),
              Text(
                  "The component requires further technical or invasive evaluation by qualified professional tradesman or service technician to determine the nature of any potential defect, the corrective action and any  associated cost.",
                  style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.pickledBluewood,
                  )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
