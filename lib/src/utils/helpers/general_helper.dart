import 'dart:io';

import 'package:flutter/foundation.dart';
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
    int counts = 1;
    if (ids.length == 0) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: (SizerUtil.deviceType == DeviceType.tablet ||
                  SizerUtil.deviceType == DeviceType.mobile)
              ? Image.asset(
                  "assets/images/default_image.png",
                  package: "pdf_report_scope",
                  fit: BoxFit.fill,
                  width: 300.sp,
                  height: 35.h,
                )
              : Image.network(
                  baseUrlLive + defaultHeaderImage1,
                  fit: BoxFit.fill,
                  width: 70.sp,
                ));
    } else {
      int remainIdsCount = (ids.length - 1);
      return ImageWithRoundedCornersForHeader(
        imageUrl: GeneralHelper.getMediaById(ids[0], media),
        // width: 300,
        height: 35.h,
        remain: remainIdsCount,
        lastItem: true,
        ids: ids,
        media: media,
      );
    }
  }

  static invalidImageText() {
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: (SizerUtil.deviceType == DeviceType.tablet ||
                  SizerUtil.deviceType == DeviceType.mobile)
              ? Image.asset(
                  "assets/images/default_image.png",
                  package: "pdf_report_scope",
                )
              : Image.network(baseUrlLive + defaultInvalidImage)),
    );
  }

  static imageHandlerForGallery(ImageShape image) {
    double scale = 0.4;
    if (kIsWeb) {
      return NetworkImage(baseUrlLive + image.url, scale: scale);
    } else {
      if ((image.url).isDeviceUrl || (image.url).isAsset) {
        return FileImage(File(image.url.envRelativePath()), scale: scale);
      } else {
        return AssetImage(image.url);
      }
    }
  }

  static imageHandlerForRoundedConner(ImageShape image, width, height) {
    if (kIsWeb) {
      return Image.network(
        baseUrlLive + image.url,
        width: width,
        height: height,
        fit: BoxFit.fill,
      );
    } else {
      if ((image.url).isDeviceUrl || (image.url).isAsset) {
        return Image.file(
          File(image.url.envRelativePath()),
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
  }

  static getMediaById(String id, List<ImageShape> media) {
    if (id.isNotEmpty && media.isNotEmpty) {
      for (var image in media) {
        if (image.id == id) {
          return image;
        }
      }
    }
    return INVALID_IMAGE;
  }

  static getMediaList(List ids, List<ImageShape> media) {
    List<ImageShape> _images = [];
    if (ids.isNotEmpty && media.isNotEmpty) {
      for (var id in ids) {
        for (var image in media) {
          if (image.id == id) {
            _images.add(image);
          }
        }
      }
    }
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
              var imageObj = GeneralHelper.getMediaById(ids[countIndex], media);
              if (imageObj is ImageShape) {
                return ImageWithRoundedCorners(
                  imageUrl: GeneralHelper.getMediaById(ids[countIndex], media),
                  width: getImageWidthHeight(imagetype, ids)[0],
                  height: getImageWidthHeight(imagetype, ids)[1],
                  counts: counts,
                );
              } else {
                return GeneralHelper.invalidImageText();
              }
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
                var imageObj =
                    GeneralHelper.getMediaById(ids[countIndex], media);
                if (imageObj is ImageShape) {
                  return ImageWithRoundedCornersV1(
                    imageUrl:
                        GeneralHelper.getMediaById(ids[countIndex], media),
                    width: getImageWidthHeight(imagetype, ids)[0],
                    height: getImageWidthHeight(imagetype, ids)[1],
                    remain: remainIdsCount,
                    lastItem: true,
                    ids: ids,
                    media: media,
                    counts: counts,
                  );
                } else {
                  return GeneralHelper.invalidImageText();
                }
              } else {
                var imageObj =
                    GeneralHelper.getMediaById(ids[countIndex], media);
                if (imageObj is ImageShape) {
                  return ImageWithRoundedCorners(
                    imageUrl:
                        GeneralHelper.getMediaById(ids[countIndex], media),
                    width: getImageWidthHeight(imagetype, ids)[0],
                    height: getImageWidthHeight(imagetype, ids)[1],
                    counts: counts,
                  );
                } else {
                  return GeneralHelper.invalidImageText();
                }
              }
            });
      }
    } else {
      return GeneralHelper.invalidImageText();
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

  static String getNameWithDots(
      String fullName, int numberOfCharWantsToDisplay) {
    // Check if the full name is less than 5 characters long
    if (fullName.length < numberOfCharWantsToDisplay) {
      // Return the full name with two dots at the end
      return fullName;
    }
    // String firstName = fullName.split(" ")[0];
    // Extract the first name from the full name
    // Extract the first five characters of the first name
    String name = (fullName.length < numberOfCharWantsToDisplay)
        ? fullName
        : fullName.substring(0, numberOfCharWantsToDisplay);
    // Add two dots at the end
    name += "..";
    return name;
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

  List<Comment> getDeficiencyComments(Template template) {
    List<Comment> deficiencyCommets = [];
    if (template.sections.isNotEmpty) {
      var sectionIndex = 0;
      //Section Comments
      for (var section in template.sections) {
        sectionIndex++;
        sectionIndex = (sectionIndex - 1);
        if (section.comments.isNotEmpty) {
          for (var sectionComment in section.comments) {
            if (sectionComment.type == CommentType.deficiency) {
              if (!sectionComment.uid.isNull &&
                  commentKeys[
                          sectionComment.id.toString() + sectionComment.uid!]
                      .isNull) {
                if (commentKeys[
                        sectionComment.id.toString() + sectionComment.uid!] !=
                    GlobalKey()) {
                  commentKeys[sectionComment.id.toString() +
                      sectionComment.uid!] = GlobalKey();
                  sectionComment.serverTimestamp = sectionIndex;
                }
              }
              deficiencyCommets.add(sectionComment);
            }
          }
        }
        //Section Item comments
        if (section.items.isNotEmpty) {
          for (var item in section.items) {
            if (item.comments.isNotEmpty) {
              for (var itemComment in item.comments) {
                if (itemComment.type == CommentType.deficiency) {
                  if (!itemComment.uid.isNull &&
                      ![itemComment.id.toString() + itemComment.uid!].isNull) {
                    commentKeys[itemComment.id.toString() + itemComment.uid!] =
                        GlobalKey();
                    itemComment.serverTimestamp = sectionIndex;
                  }
                  deficiencyCommets.add(itemComment);
                }
              }
            }
          }
        }
        if (section.subSections.isNotEmpty) {
          for (var subSection in section.subSections) {
            if (subSection.comments.isNotEmpty) {
              for (var subSectionComment in subSection.comments) {
                if (subSectionComment.type == CommentType.deficiency) {
                  if (!subSectionComment.uid.isNull &&
                      commentKeys[subSectionComment.id.toString() +
                              subSectionComment.uid!] ==
                          null) {
                    commentKeys[subSectionComment.id.toString() +
                        subSectionComment.uid!] = GlobalKey();
                    subSectionComment.serverTimestamp = sectionIndex;
                  }
                  deficiencyCommets.add(subSectionComment);
                }
              }
            }
            if (subSection.items.isNotEmpty) {
              for (var subSectionItem in subSection.items) {
                if (subSectionItem.comments.isNotEmpty) {
                  for (var subSectionItemComment in subSectionItem.comments) {
                    if (subSectionItemComment.type == CommentType.deficiency) {
                      if (!subSectionItemComment.uid.isNull &&
                          commentKeys[subSectionItemComment.id.toString() +
                                  subSectionItemComment.uid!] ==
                              null) {
                        commentKeys[subSectionItemComment.id.toString() +
                            subSectionItemComment.uid!] = GlobalKey();
                        subSectionItemComment.serverTimestamp = sectionIndex;
                      }
                      deficiencyCommets.add(subSectionItemComment);
                    }
                  }
                }
              }
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
                      aspectRatio: (SizerUtil.deviceType == DeviceType.mobile ||
                              SizerUtil.deviceType == DeviceType.tablet)
                          ? 1.2
                          : 2.6,
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
                                        ImageType.sectionImage, imageUrl)[0] /
                                    2,
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
                  Wrap(
                    direction: Axis.horizontal,
                    // mainAxisAlignment: MainAxisAlignment.center,
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
