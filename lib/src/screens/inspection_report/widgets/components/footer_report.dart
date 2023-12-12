import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/primary_heading_text_with_background.dart';

class FooterReport extends StatelessWidget {
  final Template selectedTemplate;
  const FooterReport({Key? key, required this.selectedTemplate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: ProjectColors.aliceBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const PrimaryHeadingTextWithBackground(
                    headingText: "Footer",
                    backgroundColor: ProjectColors.primary,
                    ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  selectedTemplate.reportFooter,
                  style: primaryHeadingTextStyle.copyWith(
                      fontFamily: fontFamilyJostLight,
                      fontWeight: FontWeight.w400,
                      color: ProjectColors.firefly,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
