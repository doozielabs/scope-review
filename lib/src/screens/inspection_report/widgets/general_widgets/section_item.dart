import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

// List<ImageShape> _getMedias(List<String> images, List<ImageShape> media) {
//   return media.where((_) => images.contains(_.id)).toList();
// }

class SectionItem extends StatelessWidget {
  final TemplateItem item;
  final bool isSubsectionItem;
  final List<ImageShape>? media;
  const SectionItem(
      {Key? key, required this.item, this.media, this.isSubsectionItem = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // media?.map((image) => print("Image:$image"));
    thisOrThat({
      bool weather = false,
      Widget? primary,
      Widget? secondary,
    }) {
      if (weather) {
        return primary ?? const SizedBox();
      } else {
        return secondary ?? const SizedBox();
      }
    }

    getItemValue() {
      if (item.unspecified) {
        return Text(
          "Unspecified",
          style: b3Regular.copyWith(color: ProjectColors.pickledBluewood),
        );
      }
      var value = item.value;
      switch (item.type) {
        case TemplateItemType.timestamp:
          return Text(
            GeneralHelper.getInspectionDateTimeFormat(value),
            style: b3Regular.copyWith(color: ProjectColors.pickledBluewood),
          );
        case TemplateItemType.photo:
          // return Text("TemplateItemType --- $_value");
          return GeneralHelper.displayMediaList(
              value, media!, 2, ImageType.itemImage);
        // List<ImageShape> photos =
        //     media.where((img) => (_value as List).contains(img.id)).toList();
        // return Container(
        //   padding: EdgeInsets.symmetric(
        //     vertical: 15.hs,
        //     horizontal: 20.hs,
        //   ),
        //   // color: _color(LightColors.backgroundMaterial),
        //   child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: List.generate(
        //           photos.length,
        //           (photoIndex) => photos(
        //                 photos[photoIndex].bytes,
        //                 // width: 200.hs,
        //                 height: 200.vs,
        //               ))),
        // );
        case TemplateItemType.choice:
          value ??= [];
          value as List;
          return thisOrThat(
            weather: item.defaultOption == null,
            secondary: Text(
              item.defaultOption?.value ?? "",
              style: b3Regular.copyWith(color: ProjectColors.danger),
            ),
            primary: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.isEmpty ? "".unspecified : value.join(", "),
                  style:
                      b3Regular.copyWith(color: ProjectColors.pickledBluewood),
                ),
                if (item.condition.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      text: "Condition: ",
                      style: b3Regular.copyWith(
                          color: ProjectColors.pickledBluewood),
                      children: [
                        TextSpan(
                            text: item.condition.unspecified,
                            style: b3Regular.copyWith(
                                color: item.condition.isEmpty
                                    ? ProjectColors.danger
                                    : ProjectColors.pickledBluewood)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        case TemplateItemType.text:
          return Text(
            value,
            style: b3Regular.copyWith(color: ProjectColors.pickledBluewood),
          );
        case TemplateItemType.signature:
          if (value is ImageShape) {
            return Container(
              width: 320,
              height: 95,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: GeneralHelper.imageHandlerForGallery(value),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else if (value is Map) {
            return Container(
              width: 320,
              height: 95,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: GeneralHelper.imageHandlerForGallery(
                      ImageShape.fromJson(value)),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            value = Uint8List.fromList(List<int>.from(value));
            return Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Image.memory(
                value,
                width: isTablet ? 219 : null,
                height: (isTablet ? 144 : 110),
              ),
            );
          }
        default:
          return Text(
              (value is DateTime ? value.fulldate : value.toString())
                  .unspecified,
              style: b3Regular.copyWith(color: ProjectColors.pickledBluewood));
      }
    }

    return (item.unspecified && item.images.isEmpty)
        ? const SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(
              color: ProjectColors.white,
              borderRadius: BorderRadius.circular(16),
              border: isSubsectionItem
                  ? Border.all(
                      color: ProjectColors.firefly.withOpacity(0.15),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Item Label
                  Text("${item.label.toString()} :",
                      style: secondryHeadingTextStyle.copyWith(
                        fontFamily: fontFamilyJostMedium,
                        fontWeight: FontWeight.w500,
                        color: ProjectColors.pickledBluewood,
                      )),
                  const SizedBox(height: 8),
                  //Item value
                  item.unspecified
                      ? const Padding(padding: EdgeInsets.all(0))
                      : getItemValue(),
                  const SizedBox(height: 14),
                  item.images.isNotEmpty
                      ? GeneralHelper.displayMediaList(
                          item.images, media!, 2, ImageType.itemImage)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
  }
}
