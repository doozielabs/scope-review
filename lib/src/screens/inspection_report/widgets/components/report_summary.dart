import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/constants.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/primary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/horizontal_divider_widget.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_comment_card.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class ReportSummary extends StatelessWidget {
  final Inspection inspection;
  final List<ImageShape>? media;
  const ReportSummary({Key? key, required this.inspection, required this.media})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Comment> deficiencyComments =
        GeneralHelper().getDeficiencyCommetsFromInspection(inspection);

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
              children: [
                const PrimaryHeadingTextWithBackground(
                    headingText: "report summary",
                    backgroundColor: ProjectColors.danger),
                const SizedBox(height: 14),
                Text(
                  inspection.template!.reportSummaryOptions!
                      .summaryHeader, // reportSummaryText,
                  style: secondryHeadingTextStyle.copyWith(
                      color: ProjectColors.pickledBluewood),
                ),
                const HorizontalDividerWidget(
                  color: ProjectColors.pickledBluewood,
                ),
                ...List.generate(deficiencyComments.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
                    child: SectionCommentCard(
                        needJumpToSectionButton: true,
                        comment: deficiencyComments[index],
                        commentTitle: inspection.template!
                            .commentTitle(deficiencyComments[index]),
                        media: media!),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
