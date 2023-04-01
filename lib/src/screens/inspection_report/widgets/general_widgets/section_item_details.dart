import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_item.dart';

class SectionItemDetails extends StatelessWidget {
  const SectionItemDetails({
    Key? key,
    required this.inspection,
    required this.media,
    required this.sectionIndex,
  }) : super(key: key);

  final Inspection inspection;
  final List<ImageShape> media;
  final int sectionIndex;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: inspection.template!.sections[sectionIndex].items.length,
      crossAxisCount: isMobile
          ? 1
          : isTablet
              ? 2
              : 4,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      itemBuilder: (context, itemIndex) {
        return SectionItem(
            item: inspection.template!.sections[sectionIndex].items[itemIndex],
            media: media);
      },
    );
  }
}
