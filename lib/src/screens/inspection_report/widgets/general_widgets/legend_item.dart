import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class LegendItem extends StatelessWidget {
  final String iconName;
  final String title;
  final String value;
  const LegendItem({
    Key? key,
    required this.iconName,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [SvgPicture.asset(" assets/svg/$iconName.svg")],
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: primaryHeadingTextStyle.copyWith(
                    fontFamily: fontFamilyJostMedium,
                    color: ProjectColors.black),
              ),
              Text(
                value,
                style: secondryHeadingTextStyle.copyWith(
                    color: ProjectColors.tundora),
              ),
            ],
          ),
        )
      ],
    );
  }
}
