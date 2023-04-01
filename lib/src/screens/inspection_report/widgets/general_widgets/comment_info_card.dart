import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';

class CommentInfoCard extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  const CommentInfoCard({
    Key? key,
    required this.primaryText,
    required this.secondaryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ProjectColors.firefly.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$primaryText:",
              style: secondryHeadingTextStyle.copyWith(
                color: ProjectColors.pickledBluewood,
              ),
            ),
            Flexible(
              child: Text(
                secondaryText,
                overflow: TextOverflow.ellipsis,
                style: secondryHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ProjectColors.black,
                    fontFamily: fontFamilyJostMedium),
              ),
            )
          ],
        ),
      ),
    );
  }
}
