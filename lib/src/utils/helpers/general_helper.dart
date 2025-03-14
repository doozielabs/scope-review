import 'dart:developer';
import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_real_orientation/device_orientation.dart' as dro;
import 'package:device_real_orientation/device_orientation_provider.dart'
    as dop;
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/data/models/address_model.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/data/models/template_subsection.dart';
import 'package:pdf_report_scope/src/data/models/time_zones.dart';
import 'package:pdf_report_scope/src/data/models/user_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/full_screen_video.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/video_thumb_web.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/video_viewer.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/video_thumb_app.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/constant/globals.dart';
import '../../screens/inspection_report/widgets/general_widgets/rounded_corner_image.dart';

class GeneralHelper {
  static String typeValue(value) => value.toString().split(".").last;
  static int activityIds = 0;
  static String? userTimeZone;
  static bool? daylightSaving;
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

  static getInspectionAddress(Address? address) {
    var addressString = "";
    if (address != null) {
      if (address.street.isNotEmpty) {
        addressString = (addressString + address.street);
      }
      if (address.zipcode.isNotEmpty) {
        // if (address != "") ("$addressString, ");
        addressString = ('$addressString ${address.zipcode}');
      }
      if (address.state.isNotEmpty) {
        // if (address != "") ("$addressString, ");
        addressString = ('$addressString ${address.state}');
      }
      if (address.city.isNotEmpty) {
        // if (address != "") ("$addressString, ");
        addressString = ('$addressString ${address.city}');
      }
    }
    return addressString;
  }

  static getInspectionDateTimeFormat(int timestamp) {
    // var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var dateTime = timestamp.inDateV2;
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

  static getMediaForHeader(List<String>? ids, List<ImageShape> media) {
    ImageShape? inspectionImg;
    try {
      if (ids == null) throw "No Inspection Thumbnail ID given";
      inspectionImg = media.firstWhere(
          (i) => ids.last.isHgui ? i.internalId == ids.last : i.id == ids.last);
    } catch (e) {}
    if ((ids != null && ids.isEmpty) || inspectionImg == null) {
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
              imgBaseUrl + defaultHeaderImage1,
              fit: BoxFit.cover,
              width: getHeaderImageSizesForWeb()[0],
              height: getHeaderImageSizesForWeb()[1],
            ));
      }
    } else {
      // String lastMedia = ids.last;
      int remainIdsCount = ((ids?.length ?? 1) - 1);
      if (SizerUtil.deviceType == DeviceType.mobile) {
        return ImageWithRoundedCornersForHeader(
          imageUrl:
              inspectionImg, //GeneralHelper.getMediaById(lastMedia, media),
          width: 100.w,
          boxFit: BoxFit.cover,
          remain: remainIdsCount,
          lastItem: true,
          ids: ids,
          media: media,
        );
      } else if (SizerUtil.deviceType == DeviceType.tablet) {
        return ImageWithRoundedCornersForHeader(
          imageUrl: inspectionImg,
          //GeneralHelper.getMediaById(lastMedia, media),
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
          imageUrl:
              inspectionImg, //GeneralHelper.getMediaById(lastMedia, media),
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
              : Image.network(imgBaseUrl + defaultInvalidImage)),
    );
  }

  static List<Template> sortTemplatesByBase(List<Template> templates) {
    // Sort the templates with isBaseTemplate set to true first
    return List.from(templates)
      ..sort((a, b) => (b.isBaseTemplate ?? false) ? 1 : -1);
  }

  static imageHandlerForGallery(ImageShape image) {
    double scale = 0.4;
    if (kIsWeb) {
      // return Image.network(
      //   imgBaseUrl + image.url,
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
      return NetworkImage(imgBaseUrl + image.url, scale: 1.0);
    } else {
      if ((image.url).isDeviceUrl || (image.url).isAsset) {
        return FileImage(File(image.url.envRelativePath()), scale: scale);
      } else {
        if (image.url.contains("https")) {
          return NetworkImage(image.url, scale: 1.0);
        } else {
          return AssetImage(image.url);
        }
      }
    }
  }

  static bool isVideo(String? filePath) {
    if (filePath != null) {
      final videoExtensions = ['.mp4', '.mov', '.avi'];
      final extension = filePath.split('.').last.toLowerCase();
      return videoExtensions.contains('.$extension');
    }
    return false;
  }

  static imageHandlerForRoundedConner(ImageShape image, width, height) {
    if (kIsWeb) {
      return Image.network(imgBaseUrl + image.url,
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
                      color: Color.fromARGB(255, 234, 234, 234),
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
      //   imgBaseUrl + image.url,
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

  static imageHandlerForPhotoView(ImageShape image, width, height) {
    if (kIsWeb) {
      return NetworkImage(imgBaseUrl + image.url);
    } else {
      if ((image.url).isDeviceUrl || (image.url).isAsset) {
        return FileImage(File(image.url.envRelativePath()));
      } else {
        return AssetImage(image.url);
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

  static displayMediaList(
      List<String> ids, List<ImageShape> media, int counts, imagetype) {
    List<String> filteredIds = ids
        .where((element) => media.any((media) => media.id == element))
        .toList();
    int remainIdsCount = (filteredIds.length - counts);
    int crossAxisCountAdjust = 1;
    if (filteredIds.length == 1 && imagetype == ImageType.sectionImage) {
      crossAxisCountAdjust = 2;
    } else if (filteredIds.length <
        GeneralHelper.getSizeByDevicesForImages(imagetype, counts)) {
      crossAxisCountAdjust = filteredIds.length;
    } else {
      crossAxisCountAdjust =
          GeneralHelper.getSizeByDevicesForImages(imagetype, counts);
    }
    if (crossAxisCountAdjust == 0) {
      crossAxisCountAdjust = 1;
    }
    if (filteredIds.isNotEmpty) {
      if (filteredIds.length < counts) {
        return MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredIds.length,
            crossAxisCount: crossAxisCountAdjust,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, countIndex) {
              var imageObj =
                  GeneralHelper.getMediaById(filteredIds[countIndex], media);
              if (imageObj is ImageShape) {
                return ImageWithRoundedCornersV1(
                  imageUrl: GeneralHelper.getMediaById(
                      filteredIds[countIndex], media),
                  width: getImageWidthHeight(imagetype, filteredIds)[0],
                  height: getImageWidthHeight(imagetype, filteredIds)[1],
                  remain: remainIdsCount,
                  lastItem: false,
                  ids: filteredIds,
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
                    GeneralHelper.getMediaById(filteredIds[countIndex], media);
                if (imageObj is ImageShape) {
                  // last one
                  return ImageWithRoundedCornersV1(
                    imageUrl: GeneralHelper.getMediaById(
                        filteredIds[countIndex], media),
                    width: getImageWidthHeight(imagetype, filteredIds)[0],
                    height: getImageWidthHeight(imagetype, filteredIds)[1],
                    remain: remainIdsCount,
                    lastItem: true,
                    ids: filteredIds,
                    media: media,
                    counts: counts,
                  );
                } else {
                  return GeneralHelper.invalidImageText();
                }
              } else {
                var imageObj =
                    GeneralHelper.getMediaById(filteredIds[countIndex], media);
                if (imageObj is ImageShape) {
                  return ImageWithRoundedCornersV1(
                    imageUrl: GeneralHelper.getMediaById(
                        filteredIds[countIndex], media),
                    width: getImageWidthHeight(imagetype, filteredIds)[0],
                    height: getImageWidthHeight(imagetype, filteredIds)[1],
                    remain: remainIdsCount,
                    lastItem: false,
                    ids: filteredIds,
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

  static setTrailItem(templates, selectedTemplate, inspection, user) {
    if (selectedTemplate.sections.isNotEmpty) {
      for (var section in selectedTemplate.sections) {
        // if (section.items.isNotEmpty) {
        setSectionItemsMapping(templates, section.items, inspection, user);
        // }
        if (section.subSections.isNotEmpty) {
          for (var subSection in section.subSections) {
            // if (subSection.items.isNotEmpty) {
            setSectionItemsMapping(
                templates, subSection.items, inspection, user);
            // }
          }
        }
      }
    }
    return selectedTemplate;
  }

  static setSectionItemsMapping(List<Template> templates,
      List<TemplateItem> templateItems, InspectionModel inspection, User user) {
    for (var item in templateItems) {
      bool hasValue = hasItemValue(item);
      if (!hasValue) {
        item.itemTrail?.forEach(
          (key, value) {
            switch (key) {
              case "Inspector":
              case "Inspection":
                if (value.ref != null) {
                  autoFillDetails(
                      item: item,
                      ref: value.ref!,
                      inspection: inspection,
                      user: user);
                }
                break;
              default:
                if (templates.isNotEmpty) {
                  for (var insTemplate in templates) {
                    if (insTemplate.template == key &&
                        insTemplate.isBaseTemplate == true) {
                      String itemTrail =
                          insTemplate.templateHashMap?[value.uid];
                      Id id = Id.decode(itemTrail);
                      if (id.subSection > 0) {
                        TemplateItem itemToUse = insTemplate
                            .sections[id.section - 1]
                            .subSections[id.subSection - 1]
                            .items[id.item - 1];
                        swapItemValues(item, itemToUse);
                        break;
                      } else {
                        TemplateItem itemToUse = insTemplate
                            .sections[id.section - 1].items[id.item - 1];
                        swapItemValues(item, itemToUse);
                        break;
                      }
                    }
                  }
                }
            }
          },
        );
      }
    }
  }

  static autoFillDetails(
      {required TemplateItem item,
      required String ref,
      required InspectionModel inspection,
      required User user}) {
    switch (ref) {
      case "InspectionAddress":
        item.value = inspection.address?.fullAdress;
        break;
      case "InspectionAddressStreet":
        item.value = inspection.address?.street;
        break;
      case "InspectionAddressCity":
        item.value = inspection.address?.city;
        break;
      case "InspectionAddressZipcode":
        item.value = inspection.address?.zipcode;
        break;
      case "InspectorAddressState":
        item.value = inspection.address?.state;
        break;
      case "InspectionAddressCountry":
        item.value = "United State";
        break;
      case "InspectionDate":
        item.value = inspection.startDate;
        break;
      case "ClientName":
        item.value = inspection.client.fullName;
        break;
      case "ClientPhone":
        item.value = inspection.client?.phone;
        break;
      case "ClientEmail":
        item.value = inspection.client?.email;
        break;
      case "BuyerName":
        item.value = inspection.buyerAgent.fullName;
        break;
      case "BuyerPhone":
        item.value = inspection.buyerAgent?.phone;
        break;
      case "BuyerEmail":
        item.value = inspection.buyerAgent?.email;
        break;
      case "SellerName":
        item.value = inspection.sellerAgent.fullName;
        break;
      case "SellerPhone":
        item.value = inspection.sellerAgent?.phone;
        break;
      case "SellerEmail":
        item.value = inspection.sellerAgent?.email;
        break;
      case "InspectorName":
        item.value = user.fullName;
        break;
      case "InspectorEmail":
        item.value = user.email;
        break;
      case "InspectorPhone":
        item.value = user.phone;
        break;
      case "InspectorAddress":
        item.value = user.address ?? user.companyAddress.fullAdress;
        break;
      case "InspectorAddressStreet":
        item.value = user.address ?? user.companyAddress?.street;
        break;
      case "InspectorAddressCity":
        item.value = user.address ?? user.companyAddress?.city;
        break;
      case "InspectorAddressZipcode":
        item.value = user.address ?? user.companyAddress?.zipcode;
        break;
      case "InspectionAddressState":
        item.value = user.address ?? user.companyAddress?.state;
        break;
      case "InspectorAddressCountry":
        item.value = "United State";
        break;
      case "InspectorLicense":
        item.value = user.licenseNumber;
        break;
      case "InspectorWebsite":
        item.value = user.website;
        break;
      case "InspectorOrganization":
        item.value = user.organization;
        break;
      case "InspectorSignature":
        item.value = user.signature;
        break;
      case "InspectorInitials":
        item.value = getInitials(user.firstname ?? "", user.lastname ?? "");
        break;
      default:
    }
  }

  static String getInitials(String firstName, String lastName) {
    if (firstName.isEmpty || lastName.isEmpty) {
      return '';
    }
    return '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
  }

  static swapItemValues(TemplateItem item, TemplateItem itemToUse) {
    item.value = itemToUse.value;
    item.options = itemToUse.options;
    item.completed = itemToUse.completed;
    item.condition = itemToUse.condition;
    item.visibility = itemToUse.visibility;
    item.defaultOptions = itemToUse.defaultOptions;
    item.defaultOption = itemToUse.defaultOption;
    item.conditionOptions = itemToUse.conditionOptions;
    item.prohibitConditionRating = itemToUse.prohibitConditionRating;
    item.allowMultipleSelection = itemToUse.allowMultipleSelection;
    item.images = itemToUse.images;
  }

  static bool hasItemValue(TemplateItem item) {
    switch (item.type) {
      case TemplateItemType.photo:
        var images = List<String>.from(item.value ?? []);
        if (images.isEmpty) return false;
        break;
      case TemplateItemType.choice:
        if (item.value == null || (item.value as List).isEmpty) return false;
        break;
      case TemplateItemType.signature:
        if (item.value == "" || item.value == null || item.value is Map) {
          return false;
        }
        break;
      case TemplateItemType.text:
      case TemplateItemType.email:
      case TemplateItemType.phone:
      case TemplateItemType.website:
      case TemplateItemType.currency:
      case TemplateItemType.timestamp:
      case TemplateItemType.organization:
        if (item.value == null || item.value == "") return false;
        break;
      default:
        return true;
    }
    return true;
  }

 static String getUserTimeZone(){
    // return "(UTC${(userTimeZone?? DateTime.now().timeZoneOffset.toString().split('.').first)})";
    if(userTimeZone==null || userTimeZone!.isEmpty){
      return "(GMT)";
    }
    String abbr = getTimeZoneByOffset(userTimeZone,daylightSaving: daylightSaving??false)?.abbr??'GMT';
    return abbr;
  }

static double parseTimeZoneOffsetToHours() {
  if(userTimeZone == null || userTimeZone!.isEmpty) return 0;
  String offset = userTimeZone!;
  // Check if the offset starts with a '+' or '-'
  bool isPositive = offset.startsWith('+');
  bool isNegative = offset.startsWith('-');

  // Remove the sign and split the remaining string by ':'
  String offsetWithoutSign = offset.substring(1);
  List<String> parts = offsetWithoutSign.split(':');

  // Parse hours and minutes
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  // Convert to total hours (minutes / 60)
  double totalHours = hours + (minutes / 60.0);

  // Adjust the sign if necessary
  if (isNegative) {
    totalHours = -totalHours;
  }

  return totalHours;
}

static Duration parseHoursToDuration(double? hours) {
  if(hours == null)return const Duration();
  int wholeHours = hours.truncate(); // Get the integer part of the hours
  int minutes = ((hours - wholeHours) * 60).round(); // Get the minutes part

  return Duration(hours: wholeHours, minutes: minutes);
}

static  TimeZones? getTimeZoneByOffset(String? offset,
      {bool daylightSaving = false}) {
    if (offset == null || offset.isEmpty) return null;
    return timeZoneList.firstWhere((p0) =>
        p0.offset ==
        (daylightSaving ? adjustOffset(offset, revert: true) : offset));
  }

static String adjustOffset(String offset,{bool revert = false}) {
  if(offset=='00:00'){
    offset = '+$offset';
  }
  // Check if the offset has the correct format
  if (!RegExp(r'^[+-]\d{2}:\d{2}$').hasMatch(offset)) {
    throw FormatException("Invalid offset format. It should be ±HH:MM");
  }
  
  // Extract sign, hours, and minutes
  String sign = offset[0];
  int hours = int.parse(offset.substring(1, 3));
  int minutes = int.parse(offset.substring(4, 6));
  
  // Adjust hours based on sign
  if (sign == '+') {
    revert? hours -=1 : hours  += 1;
    // Handle crossing the day boundary
    if (hours == 24) {
      hours = 0;
    }
  } else if (sign == '-') {
    revert? hours += 1 : hours -= 1;
    // Handle crossing the day boundary
    if (hours == -1) {
      hours = 23;
    }
  }
  
  // Format the new offset
  String newOffset = '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  return newOffset;
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
  @override
  Widget build(BuildContext context) {
    final List<ImageShape> imageUrl =
        GeneralHelper.getMediaList(widget.ids, widget.media);
    return LightBoxPhotoView(media: imageUrl);
  }
}

class LightBoxPhotoView extends StatefulWidget {
  final List<ImageShape> media;
  const LightBoxPhotoView({Key? key, required this.media}) : super(key: key);

  @override
  State<LightBoxPhotoView> createState() => _LightBoxPhotoViewState();
}

class _LightBoxPhotoViewState extends State<LightBoxPhotoView> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final PageController _pageController = PageController();
  late PhotoViewScaleStateController scaleStateController;
  var topContainerHeight = 8.h;
  var buttonSize = 4.h;
  var arrowSize = 10.sp;
  var isOnlyWeb = false;
  late dro.DeviceOrientation orientation;
  Key _key = const Key("1");

  @override
  void initState() {
    if (!kIsWeb) {
      orientation = dro.DeviceOrientation.portrait;

      dop.DeviceOrientationProvider.orientations.listen((orientation) {
        setState(() {
          this.orientation = orientation;
        });
      });
    } else {
      orientation = dro.DeviceOrientation.portrait;
    }
    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(printScaleState);

    super.initState();
  }

  updateVideoWidget() {
    _key = Key(DateTime.now().toIso8601String());
  }

  Future<void> selectedImage(index) async {
    _current = index;
    setState(() {
      updateVideoWidget();
    });
  }

  void zoomIn() {
    if (scaleStateController.scaleState == PhotoViewScaleState.initial) {
      scaleStateController.scaleState = PhotoViewScaleState.originalSize;
    } else if (scaleStateController.scaleState ==
        PhotoViewScaleState.originalSize) {
      scaleStateController.scaleState = PhotoViewScaleState.covering;
    }
    setState(() {});
  }

  void zoomOut() {
    if (scaleStateController.scaleState == PhotoViewScaleState.covering) {
      scaleStateController.scaleState = PhotoViewScaleState.originalSize;
    } else if (scaleStateController.scaleState ==
        PhotoViewScaleState.originalSize) {
      scaleStateController.scaleState = PhotoViewScaleState.initial;
    }
    setState(() {});
  }

  void printScaleState(PhotoViewScaleState scaleState) => {
        //     print('scaleState: $scaleState');
      };

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  callFullScreen() {
    if (kIsWeb) {
      updateVideoWidget();
      html.document.documentElement!.requestFullscreen();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FullScreenVideo(
                videoPath: widget.media[_current].url,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // if (SizerUtil.deviceType == DeviceType.mobile) {
    //   topContainerHeight = 40.sp;
    //   buttonSize = 20.sp;
    //   arrowSize = 20.sp;
    // } else if (SizerUtil.deviceType == DeviceType.tablet) {
    //   topContainerHeight = 30.sp;
    //   buttonSize = 10.sp;
    //   arrowSize = 15.sp;
    // } else if (SizerUtil.deviceType == DeviceType.web) {
    //   if (globalConstraints.maxWidth < 600) {
    //     topContainerHeight = 35.sp;
    //     buttonSize = 20.sp;
    //     arrowSize = 20.sp;
    //   } else if (globalConstraints.maxWidth < 1230) {
    //     topContainerHeight = 25.sp;
    //     buttonSize = 10.sp;
    //     arrowSize = 15.sp;
    //   }
    // }

    selectPrevious() {
      if (_current != 0) {
        scaleStateController.scaleState = PhotoViewScaleState.initial;
        _current--;
        setState(() {
          updateVideoWidget();
        });
      }
      // _pageController.animateToPage(
      //   _current,
      //   curve: Curves.fastOutSlowIn,
      //   duration: const Duration(milliseconds: 800),
      // );
    }

    selectNext() {
      if (_current != widget.media.lastIndex) {
        scaleStateController.scaleState = PhotoViewScaleState.initial;
        _current++;
        setState(() {
          updateVideoWidget();
        });
      }
      // _pageController.animateToPage(
      //   _current,
      //   curve: Curves.fastOutSlowIn,
      //   duration: const Duration(milliseconds: 800),
      // );
    }

    if (kIsWeb) {
      if (globalConstraints.maxWidth > 1230) {
        isOnlyWeb = true;
      }
    }
    log("URL: ${imgBaseUrl + widget.media[_current].url}");
    return
        // KeyboardListener(
        //   autofocus: true,
        //   focusNode: FocusManager.instance.primaryFocus!,
        //   onKeyEvent: (event) {
        //     if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
        //       selectPrevious();
        //     } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        //       selectNext();
        //     }
        //     // otherwise return this (propagates the events further to be handled elsewhere)
        //     //return keyeventresult.ignored;
        //   },
        //   child:
        Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox(
              height: height,
              width: width,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: topContainerHeight,
                      color: Colors.transparent.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isOnlyWeb &&
                                  (GeneralHelper.isVideo(
                                      widget.media[_current].url))
                              ? InkWell(
                                  onTap: () {
                                    callFullScreen();
                                  },
                                  child: Icon(
                                    Icons.fullscreen,
                                    size: buttonSize,
                                    color: ProjectColors.white,
                                  )
                                  // SvgPicture.asset(
                                  //   "assets/svg/clock_icon.svg",
                                  //   package: "pdf_report_scope",
                                  //   width: buttonSize,
                                  //   height: buttonSize,
                                  //   color: ProjectColors.white,
                                  // ),
                                  )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          isOnlyWeb &&
                                  !(GeneralHelper.isVideo(
                                      widget.media[_current].url))
                              ? Row(
                                  children: [
                                    InkWell(
                                      onTap: () => {zoomOut()},
                                      child: SvgPicture.asset(
                                        "assets/svg/Zoom-out-light.svg",
                                        package: "pdf_report_scope",
                                        width: buttonSize,
                                        height: buttonSize,
                                        color: ProjectColors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          isOnlyWeb &&
                                  !(GeneralHelper.isVideo(
                                      widget.media[_current].url))
                              ? Row(
                                  children: [
                                    InkWell(
                                      onTap: () => {zoomIn()},
                                      child: SvgPicture.asset(
                                        "assets/svg/Zoom-in-light.svg",
                                        package: "pdf_report_scope",
                                        width: buttonSize,
                                        height: buttonSize,
                                        color: ProjectColors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          InkWell(
                            onTap: () => {Navigator.pop(context)},
                            child: SvgPicture.asset(
                              "assets/svg/Close2.svg",
                              package: "pdf_report_scope",
                              width: buttonSize,
                              height: buttonSize,
                              color: ProjectColors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child:
                              // PhotoViewGallery.builder(
                              //   pageController: _pageController,
                              //   onPageChanged: (_) {
                              //     selectedImage(_);
                              //   },
                              //   scrollPhysics: const BouncingScrollPhysics(),
                              //   builder: (BuildContext context, int current) {
                              //     return GeneralHelper.isVideo(widget.media[current].url)?
                              //     PhotoViewGalleryPageOptions(
                              //         imageProvider: GeneralHelper.imageHandlerForPhotoView(
                              //           widget.media[current],
                              //           getImageWidthHeight(
                              //               ImageType.sectionImage, widget.media)[0],
                              //           getImageWidthHeight(
                              //               ImageType.sectionImage, widget.media)[1],
                              //         ),
                              //         // tightMode: true,
                              //         basePosition: Alignment.center,
                              //         initialScale: PhotoViewComputedScale.contained * 0.4,
                              //         heroAttributes: PhotoViewHeroAttributes(
                              //             tag: widget.media[current].id),
                              //         minScale: PhotoViewComputedScale.contained * 1.0,
                              //         maxScale: PhotoViewComputedScale.covered * 2.0,
                              //         scaleStateController: scaleStateController);
                              //   },
                              //   itemCount: widget.media.length,
                              //   loadingBuilder: (context, event) => Center(
                              //     child: SizedBox(
                              //       width: 50.sp,
                              //       height: 50.sp,
                              //       child: CircularProgressIndicator(
                              //         value: event == null
                              //             ? 0
                              //             : event.cumulativeBytesLoaded / 1.8,
                              //       ),
                              //     ),
                              //   ),
                              //   backgroundDecoration: BoxDecoration(
                              //     color: Colors.transparent.withOpacity(0),
                              //   ),
                              // )),
                              Container(
                            color: Colors.transparent,
                            //  height: isTablet ? 100.h : 97.h,
                            width: 100.w,
                            child: PhotoViewGestureDetectorScope(
                              axis: Axis.horizontal,
                              child: CarouselSlider.builder(
                                  carouselController: _controller,
                                  itemCount: widget.media.length,
                                  itemBuilder: (context, ind1, ind2) {
                                    print(
                                        "Path new: ${imgBaseUrl + widget.media[ind1].url}");
                                    return GeneralHelper.isVideo(
                                            widget.media[_current].url)
                                        ? RotatedBox(
                                            quarterTurns: kIsWeb || isTablet
                                                ? 0
                                                : orientation ==
                                                        dro.DeviceOrientation
                                                            .landscapeLeft
                                                    ? 1
                                                    : 0,
                                            child: VideoViewer(
                                              key: _key,
                                              address:
                                                  widget.media[_current].url,
                                              orientation: orientation,
                                            ))
                                        : PhotoView(
                                            minScale: PhotoViewComputedScale
                                                .contained,
                                            maxScale:
                                                PhotoViewComputedScale.covered *
                                                    2.0,
                                            scaleStateController:
                                                scaleStateController,
                                            imageProvider: (kIsWeb
                                                    ? NetworkImage(
                                                        imgBaseUrl +
                                                            widget.media[_current]
                                                                .url)
                                                    : widget.media[ind1].url
                                                            .isDeviceUrl
                                                        ? FileImage(File(widget
                                                            .media[_current].url
                                                            .envRelativePath()))
                                                        : FastCachedImage(
                                                        url:imgBaseUrl +
                                                            widget
                                                                .media[_current]
                                                                .url)) as ImageProvider,
                                          );
                                  },
                                  options: CarouselOptions(
                                      height: height,
                                      pageSnapping: true,
                                      initialPage: _current,
                                      onPageChanged: (index, reason) {
                                        selectedImage(index);
                                        setState(() {});
                                      },
                                      viewportFraction: 1.0,
                                      // scrollPhysics: _scrollPhysics,
                                      // scrollPhysics:
                                      //     _transformationController.value == Matrix4.identity()
                                      //         ? AlwaysScrollableScrollPhysics()
                                      //         : NeverScrollableScrollPhysics(),
                                      enableInfiniteScroll: false)),
                            ),
                          ),
                        ),
                        (widget.media.length > 1)
                            ? Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    isOnlyWeb
                                        ? InkWell(
                                            onTap: () {
                                              selectPrevious();
                                            },
                                            child: SvgPicture.asset(
                                              "assets/svg/left_chevron.svg",
                                              package: "pdf_report_scope",
                                              width: arrowSize,
                                              height: arrowSize,
                                              // color: ProjectColors.white,
                                            ))
                                        : const SizedBox(),
                                    isOnlyWeb
                                        ? InkWell(
                                            onTap: () {
                                              selectNext();
                                            },
                                            child: SvgPicture.asset(
                                              "assets/svg/right_chevron.svg",
                                              package: "pdf_report_scope",
                                              width: arrowSize,
                                              height: arrowSize,
                                              // color: ProjectColors.white,
                                            ))
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: (widget.media.length > 1)
                          ? ThumbPhotoNavigation(
                              media: widget.media,
                              current: _current,
                              // selectedImage: selectedImage,
                              // pageController: _pageController,
                              navController: _controller,
                              // setCurrent: selectedImage,
                            )
                          : const SizedBox())
                ],
              ),
            )

            // Stack(
            //   children: [

            //   ],
            // )
            // ),
            );
  }
}

class ThumbPhotoNavigation extends StatefulWidget {
  final List<ImageShape>? media;
  final int current;
  // final PageController? pageController;
  final CarouselController? navController;
  // Function? setCurrent;
  // final Function? selectedImage;

  const ThumbPhotoNavigation({
    Key? key,
    required this.media,
    // this.pageController,
    this.navController,
    // this.setCurrent,
    // this.selectedImage,
    required this.current,
  }) : super(key: key);
  @override
  State<ThumbPhotoNavigation> createState() => _ThumbPhotoNavigationState();
}

class _ThumbPhotoNavigationState extends State<ThumbPhotoNavigation> {
  var ar = 16 / 1;
  var vf = 0.1;
  var tmpIndex = 0;
  var oldIndex = 0;
  var containerwithOpacity = 0.5;
  final CarouselController _thumbController = CarouselController();

  @override
  void initState() {
    tmpIndex = widget.current;
    super.initState();
  }

  void _animateToIndex(int currentIndex, int oldIndex) {
    double width = MediaQuery.of(context).size.width;
    double numBox = 100 / ((width < 600) ? 30 : 15);
    double pages = (widget.media?.length ?? 0) / numBox;

    // if (SizerUtil.deviceType == DeviceType.mobile || width < 600) {
    //   numBox = 5.0;
    // } else if (SizerUtil.deviceType == DeviceType.tablet || width < 1230) {
    //   numBox = 5.0;
    // }
    print(
        "Numbox : ${widget.media?.length} $numBox, $pages, ${widget.current}");
    if (currentIndex < oldIndex) {
      if (currentIndex + 1 > numBox - 1) _thumbController.previousPage();
    } else {
      if (currentIndex - 1 < ((pages - 1) * numBox)) {
        _thumbController.nextPage();
      }
    }
    // if (widget.current % numBox == 0 || widget.current < oldIndex) {
    // _thumbController.animateToPage(
    //   currentIndex,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.slowMiddle,
    // );
    // }
  }

  @override
  void didUpdateWidget(covariant ThumbPhotoNavigation oldWidget) {
    if (oldWidget.current != widget.current) {
      _animateToIndex(widget.current, oldWidget.current);
      tmpIndex = widget.current;
      oldIndex = oldWidget.current;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    log("screenHeight: ${100.h} ");
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: ch,
          color: Colors.transparent.withOpacity(containerwithOpacity),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  //width:100.w,
                  height: height * 0.1,
                  child: CarouselSlider(
                    carouselController: _thumbController,
                    options: CarouselOptions(
                      aspectRatio: 4 / 3,
                      viewportFraction: width < 600 ? 0.2 : 0.1,
                      //height: 12.h,

                      reverse: false,
                      padEnds: false,
                      enableInfiniteScroll: false,
                      // initialPage: widget.current,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: widget.media!
                        .asMap()
                        .entries
                        .map((e) => Container(
                            child: Card(
                                shape: (e.key == tmpIndex)
                                    ? RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: ProjectColors.primary,
                                            width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      )
                                    : null,
                                color: Colors.transparent.withOpacity(0),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  color: Colors.transparent.withOpacity(0),
                                  child: InkWell(
                                      onTap: () {
                                        widget.navController?.jumpToPage(e.key);
                                        setState(() {});
                                      },
                                      child: GeneralHelper.isVideo(e.value.url)
                                          ? kIsWeb
                                              ? VideoThumbWeb(
                                                  videoAddress: e.value.url,
                                                  width: 90.w,
                                                  showVideoIcon: true,
                                                  height: 14.h,
                                                  fit: BoxFit.cover,
                                                )
                                              : VideoThumbApp(
                                                  path: e.value.url,
                                                  width: 90.w,
                                                  showVideoIcon: true,
                                                  height: 14.h,
                                                  fit: BoxFit.cover,
                                                )
                                          : GeneralHelper
                                              .imageHandlerForRoundedConner(
                                                  e.value, 90.w, 10.h)),
                                ))))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// Align(
//   alignment: Alignment.center,
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       InkWell(
//           onTap: () {
//             if (tmpIndex != 0) {
//               tmpIndex;
//               setState(() {});
//             }
//             widget.pageController!.animateToPage(
//               tmpIndex,
//               curve: Curves.fastOutSlowIn,
//               duration: const Duration(milliseconds: 800),
//             );
//           },
//           child: SvgPicture.asset(
//             "assets/svg/left_chevron.svg",
//             package: "pdf_report_scope",
//             width: 10.sp,
//             height: 10.sp,
//           )),
//       InkWell(
//           onTap: () {
//             if (tmpIndex != widget.media!.lastIndex) {
//               tmpIndex++;
//               setState(() {});
//             }
//             widget.pageController!.animateToPage(
//               tmpIndex,
//               curve: Curves.fastOutSlowIn,
//               duration: const Duration(milliseconds: 800),
//             );
//           },
//           child: SvgPicture.asset(
//             "assets/svg/right_chevron.svg",
//             package: "pdf_report_scope",
//             width: 10.sp,
//             height: 10.sp,
//           )),
//     ],
//   ),
// )
