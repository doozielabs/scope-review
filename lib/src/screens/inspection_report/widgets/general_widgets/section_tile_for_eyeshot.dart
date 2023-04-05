import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class SectionTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          section.name!,
          style: primaryHeadingTextStyle.copyWith(
            letterSpacing: 2,
            color: ProjectColors.primary,
            fontFamily: fontFamilyJostMedium,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              "packages/pdf_report_scope/assets/svg/comments.svg",
              width: 12,
              height: 12,
            ),
            const SizedBox(width: 7.17),
            Text(
              totalComments.toString(),
              style: b4Medium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 7.17),
            SvgPicture.asset(
              "packages/pdf_report_scope/assets/svg/deficiency.svg",
              width: 12,
              height: 12,
            ),
            const SizedBox(width: 7.17),
            Text(
              diffencyCount.toString(),
              style: b4Medium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            hasSubsections ? const SizedBox(width: 12) : const SizedBox(),
            hasSubsections
                ? SizedBox(
                    height: 23,
                    child: VerticalDivider(
                      color: ProjectColors.primary.withOpacity(0.50),
                    ),
                  )
                : const SizedBox(),
            hasSubsections ? const SizedBox(width: 12) : const SizedBox(),
            hasSubsections
                ? SvgPicture.asset(
                    "packages/pdf_report_scope/assets/svg/${isExpanded[sectionIndex] ? "expand_withoutbackground" : "unexpand_withoutbackground"}.svg",
                  )
                : const SizedBox()
          ],
        )
      ],
    );
  }
}
