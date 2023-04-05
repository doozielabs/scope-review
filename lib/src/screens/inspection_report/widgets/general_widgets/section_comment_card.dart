import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/comment_info_card.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class SectionCommentCard extends StatelessWidget {
  final String commentTitle;
  final List<ImageShape> media;
  final Comment comment;
  final bool needJumpToSectionButton;
  const SectionCommentCard({
    Key? key,
    required this.comment,
    this.needJumpToSectionButton = false,
    required this.commentTitle,
    required this.media,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: getColorAndIconForComment(comment.type!)[0].withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    commentTitle,
                    style: primaryHeadingTextStyle.copyWith(
                        color: getColorAndIconForComment(comment.type!)[0]),
                  ),
                ),
                SvgPicture.asset(
                    "packages/pdf_report_scope/lib/assets/svg/${getColorAndIconForComment(comment.type!)[1]}.svg")
              ],
            ),
            const SizedBox(height: 14),
            Text(comment.comment),
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 14.0),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  GeneralHelper.displayMediaList(
                      comment.images, media, 2, ImageType.commentImage),
                  // ...List.generate(comment.images.length, (index) {
                  //   return Padding(
                  //     padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                  //     child: ImageWithRoundedCorners(
                  //         boxFit: BoxFit.cover,
                  //         imageUrl: isWeb
                  //             ? GeneralHelper.getMediaObj(comment.images, media) //"https://picsum.photos/seed/picsum/200/300"
                  //             : GeneralHelper.getMediaObj(comment.images, media), // "assets/images/house.jpeg",
                  //         width: getImageWidthHeight(
                  //             ImageType.commentImage, comment.images)[0],
                  //         height: getImageWidthHeight(
                  //             ImageType.commentImage, comment.images)[1]),
                  //   );
                  // })
                ],
              ),
            ),
            comment.location == ""
                ? const SizedBox()
                : CommentInfoCard(
                    primaryText: "Location",
                    secondaryText: comment.location,
                  ),
            SizedBox(height: comment.level.name == "" ? 0 : 14),
            comment.level.name == ""
                ? const SizedBox()
                : CommentInfoCard(
                    primaryText: "Remediation Level",
                    secondaryText: comment.level.name,
                  ),
            needJumpToSectionButton
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        //TODO: Jump to Section Comment Callback
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Jump to Section Comment",
                            style: primaryHeadingTextStyle,
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            "packages/pdf_report_scope/lib/assets/svg/up.svg",
                            color: ProjectColors.firefly,
                            height: 18.5,
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
