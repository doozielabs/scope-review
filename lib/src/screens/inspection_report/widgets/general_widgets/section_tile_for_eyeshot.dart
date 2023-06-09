import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class SectionTile extends StatefulWidget {
  const SectionTile({
    Key? key,
    required this.section,
    required this.isExpanded,
    required this.hasSubsections,
    required this.totalComments,
    required this.diffencyCount,
    required this.sectionIndex,
    required this.inspection,
  }) : super(key: key);

  final InspectionModel inspection;
  final dynamic section;
  final List<bool> isExpanded;
  final bool hasSubsections;
  final int sectionIndex;
  final int totalComments;
  final int diffencyCount;

  @override
  State<SectionTile> createState() => _SectionTileState();
}

class _SectionTileState extends State<SectionTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: WrapCrossAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: Text(
            GeneralHelper.getNameWithDots(widget.section.name!, 15),
            style: primaryHeadingTextStyle.copyWith(
              letterSpacing: 2,
              color: ProjectColors.primary,
              fontFamily: fontFamilyJostMedium,
            ),
          ),
          onTap: () {
            int currentSectionIndex = 0;
            if ((constraintMaxWidthForNavPop < 1230)) {
              Navigator.pop(context);
            }
            if (widget.section.name == 'Information') {
              setState(() {
                Future.delayed(const Duration(microseconds: 1), () {
                  Scrollable.ensureVisible(
                    inspectionInfoKey.currentContext!,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                });
                isSearchValueChanged = false;
              });
            } else if (widget.section.name == 'Report Summary') {
              setState(() {
                summaryControllerStreamToExpand.add(1);
                Future.delayed(const Duration(microseconds: 1), () {
                  Scrollable.ensureVisible(
                    inspectionSummaryKey.currentContext!,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                });
              });
            } else {
              currentSectionIndex = widget.inspection.template!.sections
                  .indexWhere((currentSection) =>
                      currentSection.uid == widget.section.uid);
              if (currentSectionIndex != -1) {
                setState(() {
                  controllerStream.add(currentSectionIndex);
                  Future.delayed(const Duration(microseconds: 1), () {
                    Scrollable.ensureVisible(
                      itemKeys[widget.inspection.template!
                              .sections[currentSectionIndex].uid!]!
                          .currentContext!,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  });
                });
              }
              if (currentSectionIndex == -1) {
                for (int i = 0;
                    i < widget.inspection.template!.sections.length;
                    i++) {
                  for (int k = 0;
                      k <
                          widget.inspection.template!.sections[i].subSections
                              .length;
                      k++) {
                    if (widget.inspection.template!.sections[i].subSections[k]
                            .uid ==
                        widget.section.uid) {
                      setState(() {
                        controllerStream.add(i);
                        Future.delayed(const Duration(microseconds: 1), () {
                          Scrollable.ensureVisible(
                            itemKeys[widget.inspection.template!.sections[i]
                                    .subSections[k].uid!]!
                                .currentContext!,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        });
                      });
                    }
                  }
                }
              }
            }
          },
        ),
        !(widget.section.name == "Information" ||
                widget.section.name == "Report Summary")
            ? Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    "assets/svg/comments.svg",
                    package: "pdf_report_scope",
                    width: 12,
                    height: 12,
                  ),
                  const SizedBox(width: 7.17),
                  Text(
                    widget.totalComments.toString(),
                    style: b4Medium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 7.17),
                  SvgPicture.asset(
                    "assets/svg/deficiency.svg",
                    package: "pdf_report_scope",
                    width: 12,
                    height: 12,
                  ),
                  const SizedBox(width: 7.17),
                  Text(
                    widget.diffencyCount.toString(),
                    style: b4Medium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  widget.hasSubsections
                      ? const SizedBox(width: 12)
                      : const SizedBox(),
                  widget.hasSubsections
                      ? SizedBox(
                          height: 23,
                          child: VerticalDivider(
                            color: ProjectColors.primary.withOpacity(0.50),
                          ),
                        )
                      : const SizedBox(),
                  widget.hasSubsections
                      ? const SizedBox(width: 12)
                      : const SizedBox(),
                  widget.hasSubsections
                      ? Container(
                          width: 50.0,
                          height: 30.0,
                          color: Colors.transparent,
                          child: Center(
                            child: SvgPicture.asset(
                              "${widget.isExpanded[widget.sectionIndex] ? "assets/svg/expand_withoutbackground" : "assets/svg/unexpand_withoutbackground"}.svg",
                              package: "pdf_report_scope",
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              )
            : SizedBox.shrink()
      ],
    );
  }
}
