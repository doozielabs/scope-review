import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_comment_card.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class SectionItemComments extends StatelessWidget {
  const SectionItemComments({
    Key? key,
    required this.inspection,
    required this.media,
    required this.sectionIndex,
  }) : super(key: key);

  final InspectionModel inspection;
  final List<ImageShape> media;
  final int sectionIndex;

  @override
  Widget build(BuildContext context) {
    List<Comment> sectionItemComments = [];
    for (var item in inspection.template!.sections[sectionIndex].items) {
      for (var comment in item.comments) {
        sectionItemComments.add(comment);
      }
    }

    return MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: sectionItemComments.length,
        crossAxisCount: GeneralHelper.getSizeByDevicesForComments(),
        // isMobile
        //     ? 1
        //     : isTablet
        //         ? 2
        //         : 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, sectionCommentIndex) {
          return SectionCommentCard(
              // key:itemKeys[sectionItemComments[sectionCommentIndex].uid!],
              commentTitle: inspection.template!
                  .commentTitle(sectionItemComments[sectionCommentIndex]),
              comment: sectionItemComments[sectionCommentIndex],
              media: media);
        });
  }
}
