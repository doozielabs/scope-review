import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';

class VerticalHorizontalDividerWidget extends StatelessWidget {
  final double height;
  const VerticalHorizontalDividerWidget({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 1.0,
      color: ProjectColors.white.withOpacity(0.15),
    );
  }
}
