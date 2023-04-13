import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class PrimaryHeadingTextWithBackground extends StatelessWidget {
  final String headingText;
  final Color backgroundColor;
  const PrimaryHeadingTextWithBackground(
      {Key? key, required this.headingText, required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          headingText.toUpperCase(),
          style: primaryHeadingTextStyle.copyWith(
              letterSpacing: 2, color: ProjectColors.white),
        ),
      )),
    );
  }
}
