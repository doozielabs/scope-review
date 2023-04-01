import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/constants.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/legend_item.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/primary_heading_text_with_background.dart';

class Legends extends StatelessWidget {
  const Legends({Key? key}) : super(key: key);

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
                    headingText: "legends",
                    backgroundColor: ProjectColors.primary),
                ...List.generate(legendsText.length, (index) {
                  String title = legendsText.keys.elementAt(index);
                  String values = legendsText[title]["value"];
                  String icon = legendsText[title]["icon"];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 11.0, top: 11.0),
                    child: LegendItem(
                      iconName: icon,
                      title: title,
                      value: values,
                    ),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
