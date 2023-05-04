import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_comment_card.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class SectionComments extends StatelessWidget {
  const SectionComments({
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
    int crossAxisCountAdjust = 1;
    // if(inspection.template!.sections[sectionIndex].comments.length <  GeneralHelper.getSizeByDevicesForComments()){
    //   crossAxisCountAdjust = inspection.template!.sections[sectionIndex].comments.length;
    // } else {
      crossAxisCountAdjust = GeneralHelper.getSizeByDevicesForComments();
    // }
    // if(crossAxisCountAdjust ==0 || crossAxisCountAdjust ==1){
    //   crossAxisCountAdjust =1;
    // }
    return MasonryGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: inspection.template!.sections[sectionIndex].comments.length,
      crossAxisCount: crossAxisCountAdjust,
      // isMobile
      //     ? 1
      //     : isTablet
      //         ? 2
      //         : 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, sectionCommentIndex) {
        return SectionCommentCard(
            // key:itemKeys[inspection
            //     .template!.sections[sectionIndex].comments[sectionCommentIndex].uid!],
            commentTitle:
                "Comment ( ${inspection.template!.sections[sectionIndex].name} )",
            comment: inspection
                .template!.sections[sectionIndex].comments[sectionCommentIndex],
            media: media);
      },
    );
  }
}
