import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_item.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:sizer/sizer.dart';

class SectionItemDetails extends StatelessWidget {
  const SectionItemDetails({
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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (SizerUtil.deviceType == DeviceType.mobile) {
        return ItemDetailsBuilder(
          inspection: inspection,
          sectionIndex: sectionIndex,
          media: media,
          crossAxisCount: 1,
        );
      } else if (SizerUtil.deviceType == DeviceType.tablet) {
        return ItemDetailsBuilder(
          inspection: inspection,
          sectionIndex: sectionIndex,
          media: media,
          crossAxisCount: 2,
        );
      } else {
        if (constraints.maxWidth < 600) {
          //Mobile
          return ItemDetailsBuilder(
            inspection: inspection,
            sectionIndex: sectionIndex,
            media: media,
            crossAxisCount: 1,
          );
        }
        if (constraints.maxWidth < 1230) {
          //Tablet
          return ItemDetailsBuilder(
            inspection: inspection,
            sectionIndex: sectionIndex,
            media: media,
            crossAxisCount: 2,
          );
        } else {
          //Web
          return ItemDetailsBuilder(
            inspection: inspection,
            sectionIndex: sectionIndex,
            media: media,
            crossAxisCount: 5,
          );
        }
      }
    });
  }
}

class ItemDetailsBuilder extends StatelessWidget {
  const ItemDetailsBuilder({
    Key? key,
    required this.inspection,
    required this.sectionIndex,
    required this.media,
    required this.crossAxisCount,
  }) : super(key: key);

  final InspectionModel inspection;
  final int sectionIndex;
  final List<ImageShape> media;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    List<TemplateItem> filterItems = [];
    filterItems = GeneralHelper.getOnlyValidSectionItems(inspection.template!.sections[sectionIndex].items);
    return MasonryGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filterItems.length,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      itemBuilder: (context, itemIndex) {
        return SectionItem(
            item: filterItems[itemIndex],
            media: media);
      },
    );
  }
}
