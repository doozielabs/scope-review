import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class SubHeadingOfInspectionDescritpion extends StatelessWidget {
  final String primaryText;
  final String secondryText;
  const SubHeadingOfInspectionDescritpion({
    Key? key,
    required this.primaryText,
    required this.secondryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: primaryText,
        style: primaryHeadingTextStyle.copyWith(
          color: ProjectColors.firefly,
          fontSize: 16.0,
        ),
        children: <TextSpan>[
          TextSpan(
            text: " $secondryText",
            style: secondryHeadingTextStyle.copyWith(
              color: ProjectColors.pickledBluewood,
              fontWeight: FontWeight.bold,
            )
          ),
        ],
      ),
    );
  }
}
