import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/data/models/template_subsection.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
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
      if (address != "") ("$addressString, ");
      addressString = ('$addressString ' + address.zipcode);
    }
    if (address.state.isNotEmpty) {
      if (address != "") ("$addressString, ");
      addressString = ('$addressString ' + address.state);
    }
    if (address.city.isNotEmpty) {
      if (address != "") ("$addressString, ");
      addressString = ('$addressString ' + address.city);
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

  static getOnlyValidSectionItems(List<TemplateItem> items) {
    List<TemplateItem> sectionItems = [];
    for (var item in items) {
      if (!item.unspecified || item.images.isNotEmpty) {
        sectionItems.add(item);
      }
    }
    return sectionItems;
  }

  static getMediaObj(ids, List<ImageShape> media) {
    var imageUrl = "https://picsum.photos/seed/picsum/200/300";
    if (ids.isNotEmpty && media.isNotEmpty) {
      for (var id in ids) {
        for (var image in media) {
          if (image.id == id) {
            imageUrl = 'https://api.scopeinspectapp.com${image.original}';
          }
        }
      }
    }
    return imageUrl;
  }

  static List<double> getHeaderImageSizesForWeb() {
    double width = 0;
    double height = 0;
    if (globalConstraints.maxWidth < 500) {
      //Mobile
      width = 300.sp;
      height = 35.h;
      return [width, height];
    }
    if (globalConstraints.maxWidth < 1230) {
      //Tablet
      width = 120.sp;
      height = 80.h;
      return [width, height];
    } else {
      //Web
      width = 90.sp;
      height = 70.h;
      return [width, height];
    }
  }

  static getMediaForHeader(ids, List<ImageShape> media) {
    if (ids.length == 0 || ids[0].contains('hgui')) {
      if (SizerUtil.deviceType == DeviceType.mobile) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/default_image.png",
              package: "pdf_report_scope",
              fit: BoxFit.cover,
            ));
      } else if (SizerUtil.deviceType == DeviceType.tablet) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/default_image.png",
              package: "pdf_report_scope",
              fit: BoxFit.cover,
              width: 120.sp,
              height: 55.h,
            ));
      } else {
        return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              baseUrlLive + defaultHeaderImage1,
              fit: BoxFit.cover,
              width: getHeaderImageSizesForWeb()[0],
              height: getHeaderImageSizesForWeb()[1],
            ));
      }
    } else {
      String lastMedia = ids.last;
      int remainIdsCount = (ids.length - 1);
      if (SizerUtil.deviceType == DeviceType.mobile) {
        return ImageWithRoundedCornersForHeader(
          imageUrl: GeneralHelper.getMediaById(lastMedia, media),
          width: 100.w,
          boxFit: BoxFit.cover,
          remain: remainIdsCount,
          lastItem: true,
          ids: ids,
          media: media,
        );
      } else if (SizerUtil.deviceType == DeviceType.tablet) {
        return ImageWithRoundedCornersForHeader(
          imageUrl: GeneralHelper.getMediaById(lastMedia, media),
          width: 130.sp,
          boxFit: BoxFit.cover,
          height: 55.h,
          remain: remainIdsCount,
          lastItem: true,
          ids: ids,
          media: media,
        );
      } else {
        return ImageWithRoundedCornersForHeader(
          imageUrl: GeneralHelper.getMediaById(lastMedia, media),
          boxFit: BoxFit.cover,
          width: getHeaderImageSizesForWeb()[0],
          height: getHeaderImageSizesForWeb()[1],
          remain: remainIdsCount,
          lastItem: true,
          ids: ids,
          media: media,
        );
      }
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
      // return Image.network(
      //   baseUrlLive + image.url,
      //   scale: scale,
      //     loadingBuilder: (context, child, loadingProgress) {
      //       if (loadingProgress == null) {
      //         return child;
      //       } else {
      //         return const Center(
      //         child: CircularProgressIndicator(),
      //         );
      //       }
      //     },
      //     errorBuilder: (context, error, stackTrace) {
      //         return GeneralHelper.invalidImageText();
      // });
      return NetworkImage(baseUrlLive + image.url, scale: 1.0);
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
      return Image.network(baseUrlLive + image.url,
          width: width,
          height: height,
          fit: BoxFit.cover, loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const Center(
            child: SizedBox(
                height: 100,
                width: 100,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 40.0, bottom: 30.0, right: 30.0, left: 30.0),
                    child: CupertinoActivityIndicator(
                      radius: 15,
                      color: ProjectColors.firefly,
                    ))),
          );
// const Align(
//                 alignment: Alignment.bottomCenter,
//                 child: CircularProgressIndicator(),
//             );
        }
      }, errorBuilder: (context, error, stackTrace) {
        return GeneralHelper.invalidImageText();
      });
      // return Image.network(
      //   baseUrlLive + image.url,
      //   width: width,
      //   height: height,
      //   fit: BoxFit.contain,
      // );
    } else {
      if ((image.url).isDeviceUrl || (image.url).isAsset) {
        return Image.file(
          File(image.url.envRelativePath()),
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          image.url,
          width: width,
          height: height,
          fit: BoxFit.cover,
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
    List<ImageShape> images = [];
    if (ids.isNotEmpty && media.isNotEmpty) {
      for (var id in ids) {
        for (var image in media) {
          if (image.id == id) {
            images.add(image);
          }
        }
      }
    }
    return images;
  }

  static getSizeByDevicesForImages(ImageType imagetype, int counts) {
    if (SizerUtil.deviceType == DeviceType.mobile) {
      return 2;
    } else if (SizerUtil.deviceType == DeviceType.tablet) {
      return 2;
    } else {
      if (globalConstraints.maxWidth < 600) {
        //Mobile
        return 2;
      }
      if (globalConstraints.maxWidth < 1230) {
        //Tablet
        return 2;
      } else {
        //Web
        if (ImageType.sectionImage == imagetype) {
          return 4;
        } else {
          return 2;
        }
      }
    }
  }

  static getSizeByDevicesForItems() {
    if (SizerUtil.deviceType == DeviceType.mobile) {
      return 1;
    } else if (SizerUtil.deviceType == DeviceType.tablet) {
      return 2;
    } else {
      if (globalConstraints.maxWidth < 600) {
        //Mobile
        return 1;
      }
      if (globalConstraints.maxWidth < 1230) {
        //Tablet
        return 2;
      } else {
        //Web
        return 2;
      }
    }
  }

  static getSizeByDevicesForComments() {
    if (SizerUtil.deviceType == DeviceType.mobile) {
      return 1;
    } else if (SizerUtil.deviceType == DeviceType.tablet) {
      return 2;
    } else {
      if (globalConstraints.maxWidth < 600) {
        //Mobile
        return 1;
      }
      if (globalConstraints.maxWidth < 1230) {
        //Tablet
        return 2;
      } else {
        //Web
        return 3;
      }
    }
  }

  static displayMediaList(ids, List<ImageShape> media, int counts, imagetype) {
    int remainIdsCount = (ids.length - counts);
    int crossAxisCountAdjust = 1;
    if (ids.length == 1 && imagetype == ImageType.sectionImage) {
      crossAxisCountAdjust = 2;
    } else if (ids.length <
        GeneralHelper.getSizeByDevicesForImages(imagetype, counts)) {
      crossAxisCountAdjust = ids.length;
    } else {
      crossAxisCountAdjust =
          GeneralHelper.getSizeByDevicesForImages(imagetype, counts);
    }
    if (crossAxisCountAdjust == 0) {
      crossAxisCountAdjust = 1;
    }
    if (ids.length != 0) {
      if (ids.length < counts) {
        return MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ids.length,
            crossAxisCount: crossAxisCountAdjust,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, countIndex) {
              var imageObj = GeneralHelper.getMediaById(ids[countIndex], media);
              if (imageObj is ImageShape) {
                return ImageWithRoundedCornersV1(
                  imageUrl: GeneralHelper.getMediaById(ids[countIndex], media),
                  width: getImageWidthHeight(imagetype, ids)[0],
                  height: getImageWidthHeight(imagetype, ids)[1],
                  remain: remainIdsCount,
                  lastItem: false,
                  ids: ids,
                  media: media,
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
            crossAxisCount: crossAxisCountAdjust,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, countIndex) {
              if (countIndex == (counts - 1) && remainIdsCount != 0) {
                var imageObj =
                    GeneralHelper.getMediaById(ids[countIndex], media);
                if (imageObj is ImageShape) {
                  // last one
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
                  return ImageWithRoundedCornersV1(
                    imageUrl:
                        GeneralHelper.getMediaById(ids[countIndex], media),
                    width: getImageWidthHeight(imagetype, ids)[0],
                    height: getImageWidthHeight(imagetype, ids)[1],
                    remain: remainIdsCount,
                    lastItem: false,
                    ids: ids,
                    media: media,
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
        sectionIndex = (sectionIndex);
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
        sectionIndex++;
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
      var ids = id.split(connector).map((_) => int.parse(_)).toList();
      var id0 = Id();
      id0.section = ids[sectionPosition];
      id0.subSection = ids[subSectionPosition];
      id0.item = ids[itemPosition];
      id0.comment = ids[commentPosition];
      id0.image = ids[imagePosition];
      return id0;
    } else {
      var id0 = Id();
      id0.section = 0;
      id0.subSection = 0;
      id0.item = 0;
      id0.comment = 0;
      id0.image = 0;
      return id0;
    }
  }

  static Id mapOnArrayIndex(String id) {
    if (isValidId(id)) {
      var ids = id.split(connector).map((_) => int.parse(_)).toList();
      var id0 = Id();
      id0.section = ids[sectionPosition] - 1;
      id0.subSection = ids[subSectionPosition] - 1;
      id0.item = ids[itemPosition] - 1;
      id0.comment = ids[commentPosition] - 1;
      id0.image = ids[imagePosition] - 1;
      return id0;
    } else {
      var id0 = Id();
      id0.section = -1;
      id0.subSection = -1;
      id0.item = -1;
      id0.comment = -1;
      id0.image = -1;
      return id0;
    }
  }

  /// check if the string contains only numbers
  static bool isNumeric(String str) {
    RegExp numeric = RegExp(r'^-?[0-9]+$');
    return numeric.hasMatch(str);
  }

  static bool isValidId(String? id) {
    bool isValid = true;
    if (!id.isNull && id is String) {
      if (id.contains(connector)) {
        var ids = id.split(connector).map((_) => _).toList();
        if (ids.length == 5) {
          for (var val in ids) {
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
    var ids = List.generate(imagePosition.inc, (_) => 0);
    ids[sectionPosition] = section;
    ids[subSectionPosition] = subSection;
    ids[itemPosition] = item;
    ids[commentPosition] = comment;
    ids[imagePosition] = image;
    return ids.join(connector);
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
  @override
  Widget build(BuildContext context) {
    final List<ImageShape> imageUrl =
        GeneralHelper.getMediaList(widget.ids, widget.media);
    if (SizerUtil.deviceType == DeviceType.mobile) {
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
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        aspectRatio: 1,
                        enlargeCenterPage: true,
                        clipBehavior: Clip.none,
                        enableInfiniteScroll: false,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        onPageChanged: (indexed, r) =>
                            setState(() => _current = indexed),
                      ),
                      items: imageUrl
                          .map((item) => ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    GeneralHelper.imageHandlerForRoundedConner(
                                  item,
                                  getImageWidthHeight(
                                      ImageType.sectionImage, imageUrl)[0],
                                  getImageWidthHeight(
                                      ImageType.sectionImage, imageUrl)[1],
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24.0),
                    Wrap(
                      direction: Axis.horizontal,
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
                            margin:
                                EdgeInsets.only(left: index.isZero ? 0 : 10),
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
              )));
    } else if (SizerUtil.deviceType == DeviceType.tablet) {
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
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        aspectRatio: 1,
                        enlargeCenterPage: true,
                        clipBehavior: Clip.none,
                        enableInfiniteScroll: false,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        onPageChanged: (indexed, r) =>
                            setState(() => _current = indexed),
                      ),
                      items: imageUrl
                          .map((item) => ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    GeneralHelper.imageHandlerForRoundedConner(
                                  item,
                                  getImageWidthHeight(
                                      ImageType.sectionImage, imageUrl)[0],
                                  getImageWidthHeight(
                                      ImageType.sectionImage, imageUrl)[1],
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24.0),
                    Wrap(
                      direction: Axis.horizontal,
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
                            margin:
                                EdgeInsets.only(left: index.isZero ? 0 : 10),
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
              )));
    } else {
      if (globalConstraints.maxWidth < 600) {
        //Mobile (Done)
        return MyDialogue(media: imageUrl);
      } else if (globalConstraints.maxWidth < 900) {
        //Tablet
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
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150.sp,
                        child: CarouselSlider(
                          carouselController: _controller,
                          options: CarouselOptions(
                            aspectRatio: 1,
                            enlargeCenterPage: true,
                            clipBehavior: Clip.none,
                            enableInfiniteScroll: false,
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            onPageChanged: (indexed, r) =>
                                setState(() => _current = indexed),
                          ),
                          items: imageUrl
                              .map((item) => ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GeneralHelper
                                        .imageHandlerForRoundedConner(
                                      item,
                                      getImageWidthHeight(
                                          ImageType.sectionImage, imageUrl)[0],
                                      getImageWidthHeight(
                                          ImageType.sectionImage, imageUrl)[1],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Wrap(
                        direction: Axis.horizontal,
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
                              margin:
                                  EdgeInsets.only(left: index.isZero ? 0 : 10),
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
                )));
      } else if (globalConstraints.maxWidth < 1260) {
        //Tablet
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
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150.sp,
                        child: CarouselSlider(
                          carouselController: _controller,
                          options: CarouselOptions(
                            aspectRatio: 1,
                            enlargeCenterPage: true,
                            clipBehavior: Clip.none,
                            enableInfiniteScroll: false,
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            onPageChanged: (indexed, r) =>
                                setState(() => _current = indexed),
                          ),
                          items: imageUrl
                              .map((item) => ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GeneralHelper
                                        .imageHandlerForRoundedConner(
                                      item,
                                      getImageWidthHeight(
                                          ImageType.sectionImage, imageUrl)[0],
                                      getImageWidthHeight(
                                          ImageType.sectionImage, imageUrl)[1],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Wrap(
                        direction: Axis.horizontal,
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
                              margin:
                                  EdgeInsets.only(left: index.isZero ? 0 : 10),
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
                )));
      } else {
        //Web
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
            content: Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 50),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100.sp,
                              width: 100.sp,
                              child: CarouselSlider(
                                carouselController: _controller,
                                options: CarouselOptions(
                                  aspectRatio: 1,
                                  enlargeCenterPage: true,
                                  clipBehavior: Clip.none,
                                  enableInfiniteScroll: false,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.scale,
                                  onPageChanged: (indexed, r) =>
                                      setState(() => _current = indexed),
                                ),
                                items: imageUrl
                                    .map((item) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: GeneralHelper
                                              .imageHandlerForRoundedConner(
                                            item,
                                            getImageWidthHeight(
                                                ImageType.sectionImage,
                                                imageUrl)[0],
                                            getImageWidthHeight(
                                                ImageType.sectionImage,
                                                imageUrl)[1],
                                          ),
                                        ))
                                    .toList(),
                              ),
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
                                    margin: EdgeInsets.only(
                                        left: index.isZero ? 0 : 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(
                                              _current == index ? 1.0 : 0.4),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            if (_current != 0) {
                              _current--;
                              setState(() {});
                            }
                            _controller.animateToPage(
                              _current,
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 800),
                            );
                          },
                          child: SvgPicture.asset(
                            "assets/svg/left_chevron.svg",
                            package: "pdf_report_scope",
                            width: 10.sp,
                            height: 10.sp,
                          )),
                      InkWell(
                          onTap: () {
                            if (_current != imageUrl.lastIndex) {
                              _current++;
                              setState(() {});
                            }
                            _controller.animateToPage(
                              _current,
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 800),
                            );
                          },
                          child: SvgPicture.asset(
                            "assets/svg/right_chevron.svg",
                            package: "pdf_report_scope",
                            width: 10.sp,
                            height: 10.sp,
                          )),
                    ],
                  ),
                )
              ],
            ));
      }
    }
  }
}

class MyDialogue extends StatefulWidget {
  final List<ImageShape> media;

  const MyDialogue({Key? key, required this.media}) : super(key: key);

  @override
  State<MyDialogue> createState() => _MyDialogueState();
}

class _MyDialogueState extends State<MyDialogue> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.3),
        body: Padding(
          padding: EdgeInsets.all(3.sp),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  // color: Colors.red,
                  width: 100.w,
                  // height: 60.h,
                  child: SizedBox(
                      width: 100.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.h, bottom: 5.h, right: 10.w),
                              child: Row(
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
                            ),
                            CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                aspectRatio: 1,
                                enlargeCenterPage: true,
                                clipBehavior: Clip.none,
                                enableInfiniteScroll: false,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.scale,
                                onPageChanged: (indexed, r) =>
                                    setState(() => _current = indexed),
                              ),
                              items: widget.media
                                  .map((item) => ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: GeneralHelper
                                            .imageHandlerForRoundedConner(
                                                item,
                                                getImageWidthHeight(
                                                    ImageType.sectionImage,
                                                    widget.media)[0],
                                                getImageWidthHeight(
                                                    ImageType.sectionImage,
                                                    widget.media)[1]),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24.0),
                            Wrap(
                              direction: Axis.horizontal,
                              children: List.generate(
                                widget.media.length,
                                (index) => GestureDetector(
                                  onTap: () => _controller.animateToPage(
                                    index,
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(milliseconds: 800),
                                  ),
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    margin: EdgeInsets.only(
                                        left: index.isZero ? 0 : 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(
                                              _current == index ? 1.0 : 0.4),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
