import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class SecondaryHeadingTextWithBackground extends StatelessWidget {
  final String headingText;
  final Color backgroundColor;
  final Color textColor;
  const SecondaryHeadingTextWithBackground(
      {Key? key,
      required this.headingText,
      required this.backgroundColor,
      this.textColor = ProjectColors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              headingText.toUpperCase(),
              style: secondryHeadingTextStyle.copyWith(
                fontFamily: fontFamilyJostMedium,
                fontSize: 14,
                letterSpacing: 2,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
