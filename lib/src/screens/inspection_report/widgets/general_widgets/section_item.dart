import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/image.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/template_sections.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/rounded_corner_image.dart';
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

    _getItemValue() {
      var _value = item.value;
      if (_value == null || _value == "") {
        return Text(
          "".unspecified,
          style: b3Regular.copyWith(color: ProjectColors.pickledBluewood),
        );
      }
      switch (item.type) {
        case TemplateItemType.timestamp:
          return Text(
            DateTime(_value).fulldate.unspecified,
            style: b3Regular.copyWith(color: ProjectColors.pickledBluewood),
          );
        case TemplateItemType.photo:
          return Text(_value);
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
          _value ??= [];
          _value as List;
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
                  _value.isEmpty ? "".unspecified : _value.join(", "),
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
          return Text(_value);
        case TemplateItemType.signature:
          return image(
            Uint8List.fromList(_value.cast<int>()),
            width: 187,
            height: 98,
          );
        default:
          return Text(
              (_value is DateTime ? _value.fulldate : _value.toString())
                  .unspecified,
              style: b3Regular.copyWith(color: ProjectColors.pickledBluewood));
      }
    }

    return Container(
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
            Text(
              "${item.label.toString()} :",
              style: b3Medium,
            ),
            const SizedBox(height: 8),
            //Item value
            _getItemValue(),
            const SizedBox(height: 14),
            // item.images.isNotEmpty
            //     ? Padding(
            //         padding: const EdgeInsets.only(top: 14.0, bottom: 21.0),
            //         child: Wrap(
            //           direction: Axis.horizontal,
            //           children: [
            //              Padding(
            //                   padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
            //              child: GeneralHelper.displayMediaList(item.images, media!, 2, ImageType.itemImage),
            //              ),
            //             // ...List.generate(
            //             //   item.images.length,
            //             //   (index) {
            //             //     return Padding(
            //             //       padding:
            //             //           const EdgeInsets.only(left: 5.0, bottom: 5.0),
            //             //           child: item.images.length == 1
            //             //           ? ImageWithRoundedCorners(
            //             //               imageUrl: isWeb
            //             //                   ? GeneralHelper.getMediaObj(item.images, media!) //"https://picsum.photos/seed/picsum/200/300" //"${item.images[0]}"//"https://picsum.photos/seed/picsum/200/300"
            //             //                   : GeneralHelper.getMediaObj(item.images, media!), //"assets/images/house.jpeg",
            //             //               width: getImageWidthHeight(
            //             //                   ImageType.itemImage, item.images)[0],
            //             //               height: getImageWidthHeight(
            //             //                   ImageType.itemImage, item.images)[1],
            //             //             )
            //             //           : ImageWithRoundedCorners(
            //             //               imageUrl: isWeb
            //             //                   ? GeneralHelper.getMediaObj(item.images, media!) //"https://picsum.photos/seed/picsum/200/300"
            //             //                   : GeneralHelper.getMediaObj(item.images, media!),  //"assets/images/house.jpeg",
            //             //               width: getImageWidthHeight(
            //             //                   ImageType.itemImage, item.images)[0],
            //             //               height: getImageWidthHeight(
            //             //                   ImageType.itemImage, item.images)[1],
            //             //             ),
            //             //     );
            //             //   },
            //             // )
            //           ],
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
