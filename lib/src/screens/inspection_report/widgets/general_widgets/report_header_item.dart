import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class HeaderInfoItem extends StatelessWidget {
  final String iconName;
  final String text;
  const HeaderInfoItem({
    Key? key,
    required this.iconName,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "packages/pdf_report_scope/assets/svg/$iconName.svg",
          package: "pdf_report_scope",
        ),
        const SizedBox(width: 10),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: secondryHeadingTextStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
