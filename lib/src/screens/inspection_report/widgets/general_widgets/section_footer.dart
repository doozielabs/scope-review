import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class SectionFooter extends StatelessWidget {
  final String title;
  final String value;
  const SectionFooter({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 5),
        // Text(
        //   "${title.capitalize}'s Footer: ",
        //   style: primaryHeadingTextStyle.copyWith(
        //       fontFamily: fontFamilyJostMedium,
        //       color: ProjectColors.firefly,
        //       fontSize: 14),
        // ),
        Text(
          value,
          style: primaryHeadingTextStyle.copyWith(
              fontFamily: fontFamilyJostLight,
              fontWeight: FontWeight.w400,
              color: ProjectColors.firefly,
              fontSize: 14),
              textAlign:TextAlign.center,
        ),
      const SizedBox(height: 10),  
      ],
    );
  }
}
