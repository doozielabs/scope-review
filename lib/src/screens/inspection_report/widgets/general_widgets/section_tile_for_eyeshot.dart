import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
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
  }) : super(key: key);

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
            controllerStream.add(widget.sectionIndex);
            Future.delayed(const Duration(seconds: 1), () {
              Scrollable.ensureVisible(
                itemKeys[widget.section.uid!]!.currentContext!,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        Row(
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
                    width: 30.0,
                    height: 30.0,
                    color: Colors.transparent,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svg/${widget.isExpanded[widget.sectionIndex] ? "expand_withoutbackground" : "unexpand_withoutbackground"}.svg",
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        )
      ],
    );
  }
}
