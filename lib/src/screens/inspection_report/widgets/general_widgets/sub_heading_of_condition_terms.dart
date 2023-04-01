import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class SubHeadingOfConditionTerms extends StatelessWidget {
  final String primaryText;
  final String secondryText;
  const SubHeadingOfConditionTerms({
    Key? key,
    required this.primaryText,
    required this.secondryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "$primaryText\n",
        style: const TextStyle(
            color: ProjectColors.firefly,
            fontSize: 18.0,
            fontFamily: fontFamilyJostMedium),
        children: <TextSpan>[
          TextSpan(
            text: secondryText,
            style: const TextStyle(
                fontSize: 16.0,
                color: ProjectColors.pickledBluewood,
                fontFamily: fontFamilyJostRegular),
          ),
        ],
      ),
    );
  }
}
