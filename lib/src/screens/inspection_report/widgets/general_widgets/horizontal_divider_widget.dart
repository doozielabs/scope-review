import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';

class HorizontalDividerWidget extends StatelessWidget {
  final Color color;
  final double? padding;
  const HorizontalDividerWidget({
    Key? key,
    this.color = ProjectColors.white,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: padding ?? 20.0,
          right: padding ?? 20.0,
          top: padding ?? 10.0,
          bottom: padding ?? 10.0),
      child: Container(
        height: 1.0,
        width: double.infinity,
        color: color.withOpacity(0.15),
      ),
    );
  }
}
