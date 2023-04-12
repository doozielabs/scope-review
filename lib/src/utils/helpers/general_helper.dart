import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/data/models/template_subsection.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
// import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/globals.dart';
import '../../screens/inspection_report/widgets/general_widgets/rounded_corner_image.dart';

class GeneralHelper {
  static String typeValue(value) => value.toString().split(".").last;
  static int activityIds = 0;
  // static bool syncInProgress = false;
  // Inspection onRefresh function

  //TODO: define callback for images byId
  static dynamic getType(List values, String name, String type) {
    int index = values.indexWhere((value) => value.toString() == '$name.$type');

    if (index.isNegative) {
      return values.isEmpty ? "" : values[0];
    } else {
      return values[index];
    }
  }

  static getInspectionAddress(address) {
    var addressString = "";
    if (address.street.isNotEmpty) {
      addressString = (addressString + address.street);
    }
    if (address.zipcode.isNotEmpty) {
      if (address != "") (addressString + ", ");
      addressString = (addressString + ' ' + address.zipcode);
    }
    if (address.state.isNotEmpty) {
      if (address != "") (addressString + ", ");
      addressString = (addressString + ' ' + address.state);
    }
    if (address.city.isNotEmpty) {
      if (address != "") (addressString + ", ");
      addressString = (addressString + ' ' + address.city);
    }
    return addressString;
  }

  static getInspectionDateTimeFormat(timestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter =
        DateFormat('E d\'${getDayOfMonthSuffix(dateTime.day)}\' MMMM - h:mm a');
    return formatter.format(dateTime);
  }

  static String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static int indexConductor(int index, List list, {int noWhere = -1}) {
    if (!list.asMap().containsKey(index)) {
      if (!(index - 1).isNegative) {
        return index - 1;
      } else if ((index + 1) < list.length) {
        return index + 1;
      } else {
        return noWhere;
      }
    } else {
      return index;
    }
  }

  static getMediaObj(ids, List<ImageShape> media) {
    var imageUrl = "https://picsum.photos/seed/picsum/200/300";
    if (ids.isNotEmpty && media.isNotEmpty) {
      for (var id in ids) {
        for (var image in media) {
          if (image.id == id) {
            imageUrl = 'https://api.scopeinspectapp.com' + image.original;
          }
        }
      }
    }
    return imageUrl;
  }

  static getMediaForHeader(ids, List<ImageShape> media) {
    // print("id header :$ids  -- ${GeneralHelper.getMediaById(ids[0], media)}");
    // print("Media:$media");
    int counts = 1;

    if (ids.length == 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isWeb
            ? Image.network(baseUrlLive + defaultHeaderImage1)
            : Image.asset(
                "assets/images/default_image.png",
                package: "pdf_report_scope",
                // width: 300,
                // height: 300,
              ),
      );
      // return ImageWithRoundedCorners(
      //   imageUrl: GeneralHelper.getMediaById(ids[0], media),
      //   width: 300,
      //   height: 300,
      //   counts: counts,
      // );
    } else {
      int remainIdsCount = (ids.length - 1);
      // print("--${GeneralHelper.getMediaById(ids[0], media)}");
      // return Image.network(
      //     "https://api.scopeinspectapp.com/images/inspection_placeholder.png");
      return ImageWithRoundedCornersForHeader(
        imageUrl: GeneralHelper.getMediaById(ids[0], media),
        // width: 70.w,
        height: 35.h,
        // height: 100.h,
        remain: remainIdsCount,
        lastItem: true,
        ids: ids,
        media: media,
      );
    }
  }

  static imageHandlerForGallery(ImageShape image) {
    if ((image.url).isDeviceUrl || (image.url).isAsset) {
      return FileImage(File(image.url));
    } else if (!(image.url).isDeviceUrl && !(image.url).isAsset) {
      return NetworkImage(baseUrlLive + image.original);
    } else {
      return AssetImage(image.url);
    }
  }

  static imageHandlerForRoundedConner(ImageShape image, width, height) {
    if ((image.url).isDeviceUrl || (image.url).isAsset) {
      return Image.file(
        File(image.url),
        width: width,
        height: height,
        fit: BoxFit.fill,
      );
    } else if (!(image.url).isDeviceUrl && !(image.url).isAsset) {
      return Image.network(
        baseUrlLive + image.original,
        width: width,
        height: height,
        fit: BoxFit.fill,
      );
    } else {
      return Image.asset(
        image.url,
        width: width,
        height: height,
        fit: BoxFit.fill,
      );
    }
  }

  static getMediaById(String id, List<ImageShape> media) {
    var imageUrl = baseUrlLive + defaultHeaderImage;
    if (id.isNotEmpty && media.isNotEmpty) {
      for (var image in media) {
        if (image.id == id) {
          return image;
          // if (isWeb) {
          //   return imageUrl = baseUrlLive + image.original;
          // } else {
          //   return imageUrl = baseUrlLive + image.url;
          // }
        }
      }
    }
    return imageUrl;
  }

  static getMediaList(List ids, List<ImageShape> media) {
    List<ImageShape> _images = [];
    if (ids.isNotEmpty && media.isNotEmpty) {
      for (var id in ids) {
        for (var image in media) {
          if (image.id == id) {
            _images.add(image);
            // return _image;
            // if (isWeb) {
            //   _images.add(baseUrlLive + image.original);
            // } else {
            //   _images.add(baseUrlLive + image.url);
            // }
          }
        }
      }
    }

    // if (_images.isEmpty) {
    //   _images = [baseUrlLive + defaultHeaderImage];
    // }
    return _images;
  }

  static displayMediaList(ids, List<ImageShape> media, int counts, imagetype) {
    int remainIdsCount = (ids.length - counts);
    if (ids.length != 0) {
      if (ids.length < counts) {
        return MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ids.length,
            crossAxisCount: isMobile ? 2 : ids.length,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, countIndex) {
              return ImageWithRoundedCorners(
                imageUrl: GeneralHelper.getMediaById(ids[countIndex], media),
                width: getImageWidthHeight(imagetype, ids)[0],
                height: getImageWidthHeight(imagetype, ids)[1],
                counts: counts,
              );
            });
      } else {
        return MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: counts,
            crossAxisCount: isMobile ? 2 : counts,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, countIndex) {
              if (countIndex == (counts - 1) && remainIdsCount != 0) {
                return ImageWithRoundedCornersV1(
                  imageUrl: GeneralHelper.getMediaById(ids[countIndex], media),
                  width: getImageWidthHeight(imagetype, ids)[0],
                  height: getImageWidthHeight(imagetype, ids)[1],
                  remain: remainIdsCount,
                  lastItem: true,
                  ids: ids,
                  media: media,
                  counts: counts,
                );
              } else {
                return ImageWithRoundedCorners(
                  imageUrl: GeneralHelper.getMediaById(ids[countIndex], media),
                  width: getImageWidthHeight(imagetype, ids)[0],
                  height: getImageWidthHeight(imagetype, ids)[1],
                  counts: counts,
                );
              }
            });
      }
    } else {
      return const Text("");
    }
  }

  static bool isTypeTemplate(val) => val is Template;

  static bool isTypeInspection(val) => val is InspectionModel;

  static bool isTypeSection(val) => val is TemplateSection;

  static bool isTypeSubsection(val) => val is TemplateSubSection;

  static bool isListOfTypeSection(val) => val is List<TemplateSection>;

  static bool isListOfTypeSubsection(val) => val is List<TemplateSubSection>;

  static modifible(List list) {
    if (list.isEmpty) list = [];
  }

  static showSnackBar(
    BuildContext context, {
    Color? color,
    String text = "",
    Color? background,
    int milliseconds = 300,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: milliseconds),
        backgroundColor:
            background ?? Theme.of(context).scaffoldBackgroundColor,
        content: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontFamily: "sansPro-semiBold",
            color: color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  List<Comment> getDeficiencyCommetsFromInspection(InspectionModel inspection) {
    List<Comment> deficiencyCommets = [];
    final sections = inspection.template!.sections;
    //Looping the sections
    for (var sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
      //section comments
      for (var commentIndex = 0;
          commentIndex < sections[sectionIndex].comments.length;
          commentIndex++) {
        final comment = sections[sectionIndex].comments[commentIndex];
        if (comment.type == CommentType.deficiency) {
          deficiencyCommets.add(comment);
        }
      }
      //Section items comments
      for (var itemIndex = 0;
          itemIndex < sections[sectionIndex].items.length;
          itemIndex++) {
        final item = sections[sectionIndex].items[itemIndex];
        for (var i = 0; i < item.comments.length; i++) {
          if (item.comments[i].level == CommentType.deficiency) {
            deficiencyCommets.add(item.comments[i]);
          }
        }
      }
      //Subsections
      final subSections = sections[sectionIndex].subSections;
      for (var subSectionIndex = 0;
          subSectionIndex < subSections.length;
          subSectionIndex++) {
        for (var subSectioncommentIndex = 0;
            subSectioncommentIndex <
                subSections[subSectionIndex].comments.length;
            subSectioncommentIndex++) {
          final subsSectionComment =
              subSections[subSectionIndex].comments[subSectioncommentIndex];
          if (subsSectionComment.type == CommentType.deficiency) {
            deficiencyCommets.add(subsSectionComment);
          }
        }
        for (var subSectionitemIndex = 0;
            subSectionitemIndex < subSections[subSectionIndex].items.length;
            subSectionitemIndex++) {
          final item = subSections[subSectionIndex].items[subSectionitemIndex];
          for (var i = 0; i < item.comments.length; i++) {
            if (item.comments[i].level == CommentType.deficiency) {
              deficiencyCommets.add(item.comments[i]);
            }
          }
        }
      }
    }
    return deficiencyCommets;
  }
}

class Id {
  int section;
  int subSection;
  int item;
  int comment;
  int image;

  Id({
    this.section = 0,
    this.subSection = 0,
    this.item = 0,
    this.comment = 0,
    this.image = 0,
  });

  static String connector = ".";
  static int sectionPosition = 0;
  static int subSectionPosition = 1;
  static int itemPosition = 2;
  static int commentPosition = 3;
  static int imagePosition = 4;

  static Id decode(String id) {
    if (isValidId(id)) {
      var _ids = id.split(connector).map((_) => int.parse(_)).toList();
      var _id = Id();
      _id.section = _ids[sectionPosition];
      _id.subSection = _ids[subSectionPosition];
      _id.item = _ids[itemPosition];
      _id.comment = _ids[commentPosition];
      _id.image = _ids[imagePosition];
      return _id;
    } else {
      var _id = Id();
      _id.section = 0;
      _id.subSection = 0;
      _id.item = 0;
      _id.comment = 0;
      _id.image = 0;
      return _id;
    }
  }

  static Id mapOnArrayIndex(String id) {
    if (isValidId(id)) {
      var _ids = id.split(connector).map((_) => int.parse(_)).toList();
      var _id = Id();
      _id.section = _ids[sectionPosition] - 1;
      _id.subSection = _ids[subSectionPosition] - 1;
      _id.item = _ids[itemPosition] - 1;
      _id.comment = _ids[commentPosition] - 1;
      _id.image = _ids[imagePosition] - 1;
      return _id;
    } else {
      var _id = Id();
      _id.section = -1;
      _id.subSection = -1;
      _id.item = -1;
      _id.comment = -1;
      _id.image = -1;
      return _id;
    }
  }

  /// check if the string contains only numbers
  static bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  static bool isValidId(String? id) {
    bool isValid = true;
    if (!id.isNull && id is String) {
      if (id.contains(connector)) {
        var _ids = id.split(connector).map((_) => _).toList();
        if (_ids.length == 5) {
          for (var val in _ids) {
            if (!isNumeric(val)) {
              isValid = false;
            }
          }
        } else {
          isValid = false;
        }
      } else {
        isValid = false;
      }
    } else {
      isValid = false;
    }
    return isValid;
  }

  String id() {
    var _ids = List.generate(imagePosition.inc, (_) => 0);
    _ids[sectionPosition] = section;
    _ids[subSectionPosition] = subSection;
    _ids[itemPosition] = item;
    _ids[commentPosition] = comment;
    _ids[imagePosition] = image;
    return _ids.join(connector);
  }

  List<int> collection() =>
      id().split(connector).map((_) => int.parse(_)).toList();

  bool haveSection() => collection()[sectionPosition] > 0;
  bool haveSubSection() => collection()[subSectionPosition] > 0;
  bool haveItem() => collection()[itemPosition] > 0;
  bool haveComment() => collection()[commentPosition] > 0;
  bool haveImage() => collection()[imagePosition] > 0;
  bool haveOnlyImage() =>
      !haveSection() &&
      !haveSubSection() &&
      !haveItem() &&
      !haveComment() &&
      haveImage();
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.ids,
    required this.media,
  }) : super(key: key);
  final List ids;
  final List<ImageShape> media;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  // dialogContent(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.grey[850],
  //       shape: BoxShape.rectangle,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Align(
  //             alignment: Alignment.topRight,
  //             child: TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Icon(Icons.cancel),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 24.0),
  //         _indicators(),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final List<ImageShape> imageUrl =
        GeneralHelper.getMediaList(widget.ids, widget.media);
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/svg/close.svg",
              package: "pdf_report_scope",
              color: ProjectColors.white,
            ),
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      // content: dialogContent(context),
      content: SizedBox(

          // decoration: BoxDecoration(
          //   color: Colors.grey[850],
          //   shape: BoxShape.rectangle,
          //   borderRadius: BorderRadius.circular(20),
          // ),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50),
              child: Column(
                children: [
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      aspectRatio: 1.2,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale,
                      onPageChanged: (indexed, r) =>
                          setState(() => _current = indexed),
                    ),
                    items: imageUrl
                        .map((item) => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GeneralHelper.imageHandlerForRoundedConner(
                                item,
                                getImageWidthHeight(
                                    ImageType.sectionImage, imageUrl)[0],
                                getImageWidthHeight(
                                    ImageType.sectionImage, imageUrl)[1],
                              ),

                              // Image.network(
                              //   item.url,
                              //   fit: BoxFit.cover,
                              // ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imageUrl.length,
                      (index) => GestureDetector(
                        onTap: () => _controller.animateToPage(
                          index,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 800),
                        ),
                        child: Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.only(left: index.isZero ? 0 : 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(_current == index ? 1.0 : 0.4),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
