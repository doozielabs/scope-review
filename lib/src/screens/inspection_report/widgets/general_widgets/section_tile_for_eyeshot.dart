import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
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
            if ((constraintMaxWidthForNavPop < 1230)) {
              Navigator.pop(context);
            }
            if (isSearchValueChanged) {
              if (widget.section.name == 'Information') {
                setState(() {
                  Future.delayed(const Duration(microseconds: 1), () {
                    Scrollable.ensureVisible(
                      inspectionInfoKey.currentContext!,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  });
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
                int currentSectionIndex = widget.inspection.template!.sections
                    .indexWhere((currentSection) =>
                        currentSection.name == widget.section.name);
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
            } else if (widget.sectionIndex == 0) {
              setState(() {
                Future.delayed(const Duration(microseconds: 1), () {
                  Scrollable.ensureVisible(
                    inspectionInfoKey.currentContext!,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                });
              });
            } else if (widget.sectionIndex == 1) {
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
              if (isSearchValueChanged) {
                // print(
                //     "${widget.isExpanded} search --index:${widget.sectionIndex}");
                // // int searchIndex = (widgetisExpanded);
                // setState(() {
                //   controllerStream.add(widget.sectionIndex - 2);
                //   Future.delayed(const Duration(microseconds: 1), () {
                //     Scrollable.ensureVisible(
                //       itemKeys[widget.section.uid!]!.currentContext!,
                //       duration: const Duration(milliseconds: 400),
                //       curve: Curves.easeInOut,
                //     );
                //   });
                // });
              } else {
                print("baki sare --index:${widget.sectionIndex}");
                setState(() {
                  controllerStream.add(widget.sectionIndex - 2);
                  Future.delayed(const Duration(microseconds: 1), () {
                    Scrollable.ensureVisible(
                      itemKeys[widget.section.uid!]!.currentContext!,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  });
                });
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
                          width: 20.0,
                          height: 30.0,
                          color: Colors.transparent,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svg/${widget.isExpanded[widget.sectionIndex] ? "expand_withoutbackground" : "unexpand_withoutbackground"}.svg",
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
