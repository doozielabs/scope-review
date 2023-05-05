import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/horizontal_divider_widget.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_comment_card.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class ReportSummary extends StatefulWidget {
  final InspectionModel inspection;
  final List<ImageShape>? media;
  const ReportSummary({Key? key, required this.inspection, required this.media})
      : super(key: key);

  @override
  State<ReportSummary> createState() => _ReportSummaryState();
}

class _ReportSummaryState extends State<ReportSummary> {
  
  @override
  void initState() {
    summaryControllerStreamToExpand.stream.listen((index) {
      setState(() {
        isSummaryExpanded = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> deficiencyComments =
        GeneralHelper().getDeficiencyComments(widget.inspection.template!);

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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSummaryExpanded = !isSummaryExpanded;
                    });
                  },
                  child: Container(
                    height: 37.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: ProjectColors.danger,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "report summary".toUpperCase(),
                            // key: itemKeys[inspection
                            //     .template!.sections[sectionIndex].uid],
                            style: primaryHeadingTextStyle.copyWith(
                                letterSpacing: 2,
                                color: ProjectColors.white,
                                fontFamily: fontFamilyJostMedium),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            "assets/svg/${isSummaryExpanded ? "unexpand_withoutbackground" : "expand_withoutbackground"}.svg",
                            package: "pdf_report_scope",
                            width: 7,
                            height: 7,
                            color: ProjectColors.white,
                          ),
                        )
                      ],
                    )),
                  ),
                ),
                isSummaryExpanded
                    ? Column(
                        children: [
                          const SizedBox(height: 14),
                          Text(
                            widget.inspection.template!.reportSummaryOptions!
                                .summaryHeader, // reportSummaryText,
                            style: secondryHeadingTextStyle.copyWith(
                                color: ProjectColors.pickledBluewood),
                          ),
                          const HorizontalDividerWidget(
                            color: ProjectColors.pickledBluewood,
                          ),
                           MasonryGridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: deficiencyComments.length,
                            crossAxisCount: isMobile
                                ? 1
                                : isTablet
                                    ? 2
                                    : 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            itemBuilder: (context, index) {
                              return SectionCommentCard(
                                  // key:itemKeys[inspection
                                  //     .template!.sections[sectionIndex].comments[sectionCommentIndex].uid!],
                                  needJumpToSectionButton: true,
                                  commentTitle:widget.inspection.template!.commentTitle(deficiencyComments[index]),
                                  comment: deficiencyComments[index],
                                  media: widget.media!);
                            },
                          )
                          // ...List.generate(deficiencyComments.length, (index) {
                          //   return Padding(
                          //     padding:
                          //         const EdgeInsets.only(top: 7.0, bottom: 7.0),
                          //     child: SectionCommentCard(
                          //       needJumpToSectionButton: true,
                          //       comment: deficiencyComments[index],
                          //       commentTitle: widget.inspection.template!
                          //           .commentTitle(deficiencyComments[index]),
                          //       media: widget.media!,
                          //     ),
                          //   );
                          // })
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ));
  }
}
