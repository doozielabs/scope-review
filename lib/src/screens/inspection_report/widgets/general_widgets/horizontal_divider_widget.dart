import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';

class HorizontalDividerWidget extends StatelessWidget {
  final Color color;
  const HorizontalDividerWidget({
    Key? key,
    this.color = ProjectColors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        height: 1.0,
        width: double.infinity,
        color: color.withOpacity(0.15),
      ),
    );
  }
}
