import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:sizer/sizer.dart';

// const baseUrl = 'https://api.scopeinspectapp.com'; // Production
const baseUrl = 'https://staging-api.scopeinspectapp.com'; // Staging
// const baseUrl = 'http://localhost:1337'; // Local
// const baseUrl = 'http://192.168.88.15:1337';

// const imgBaseUrl = 'https://cdn.scopeinspectapp.com'; // Production
const imgBaseUrl = 'https://scdn.scopeinspectapp.com'; // Staging
// const imgBaseUrl = 'http://localhost:1337'; // Local
// const imgBaseUrl = 'http://192.168.88.15:1337';

const defaultHeaderImage1 = '/images/inspection_placeholder.png';
const defaultHeaderImage = "/images/house.jpeg";
const pdfGeneration = "/images/pdf-generation.gif";
const pdfGenerated = "/images/pdf-generated.png";
const generationPdf = "/images/generation-pdf.gif";
const generatedPdf = "/images/generated-pdf.gif";
const defaultInvalidImage = "/images/invalid-placholder.png";
String documentDirectory = "";

const double kMobileMaxWidth = 550.0;
const double kTabletMaxWidth = 959.0;
const double kDesktopMinWidth = 960.0;
const double headerHeight = 5000;
BoxConstraints globalConstraints = const BoxConstraints();

final ScrollController mainListviewController = ScrollController();
final ScrollController sectionsListviewController = ScrollController();
final ScrollController sectionCommentsController = ScrollController();
final ScrollController subSectionsListviewController = ScrollController();
final ScrollController subSectionCommentsController = ScrollController();

Map<String, GlobalKey> itemKeys = {};
Map<String, GlobalKey> commentKeys = {};
final inspectionInfoKey = GlobalKey();
final inspectionSummaryKey = GlobalKey();
const inspectionInfoIndex = 0;
const inspectionSummaryIndex = 1;
bool isSummaryExpanded = false;
bool expandSummary = false;
bool isSearchValueChanged = false;
late List<TemplateSection> filteredSection;
const INVALID_IMAGE = "invalid Media";
double constraintMaxWidthForNavPop = 0.0;
StreamController<double> constraintStream =
    StreamController<double>.broadcast(sync: true);
StreamController<int> controllerStream = StreamController<int>.broadcast();
StreamController<int> summaryControllerStreamToExpand =
    StreamController<int>.broadcast();

enum DeviceTypeForWeb {
  mobile,
  tablet,
  web,
}

final isMobile = SizerUtil.deviceType == DeviceType.mobile;
final isTablet = SizerUtil.deviceType == DeviceType.tablet;
final isWeb = SizerUtil.deviceType == DeviceType.web;

enum ImageType {
  commentImage,
  sectionImage,
  itemImage,
}

// Future<double> getItemHeight(int index) async {
//   await Future.delayed(Duration.zero);
//   final RenderBox? renderBox =
//       itemKeys[index]?.currentContext?.findRenderObject() as RenderBox?;
//   if (renderBox != null) {
//     print("Height:${renderBox.size.height}");
//     return renderBox.size.height;
//   } else {
//     return 0.0; // or any default value you want to return
//   }
// }

// Future<double> getHeightOfWidget(int index) async {
//   double height = 0;
//   for (var i = 0; i < index; i++) {
//     double temp = await getItemHeight(i);
//     height += temp;
//     print("Height:$height");
//   }
//   return height;
// }

setKeysForFilteredSection(sections) {
  for (var sectionKeys in sections) {
    if (itemKeys[sectionKeys.uid] == null) {
      itemKeys[sectionKeys.uid!] = GlobalKey();
    }
    for (var subSectionKeys in sectionKeys.subSections) {
      if (itemKeys[subSectionKeys.uid] == null) {
        itemKeys[subSectionKeys.uid!] = GlobalKey();
      }
    }
  }
}

List getImageWidthHeight(ImageType imageType, List<dynamic>? images) {
  double imageWidth;
  double imageHeight;
  bool isSingleImage = images!.length == 1;
  switch (imageType) {
    case ImageType.commentImage:
      if (isSingleImage) {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile SinlgeImage -- Comment Media
          imageWidth = 100.w;
          imageHeight = 26.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet SinlgeImage -- Comment
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          if (globalConstraints.maxWidth < 600) {
            imageWidth = 100.w;
            imageHeight = 26.h;
          } else if (globalConstraints.maxWidth < 1230) {
            imageWidth = 100.w;
            imageHeight = 25.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 50.h;
          }
        }
      } else {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile multiple Media -- Comment Media
          imageWidth = 100.w;
          imageHeight = 26.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet multiple Media -- Comment Media
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          //Web multiple Media -- Comment Media
          if (globalConstraints.maxWidth < 600) {
            imageWidth = 100.w;
            imageHeight = 26.h;
          } else if (globalConstraints.maxWidth < 1230) {
            imageWidth = 100.w;
            imageHeight = 20.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 40.h;
          }
        }
      }
      return [imageWidth, imageHeight];
    case ImageType.sectionImage:
      if (isSingleImage) {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile SinlgeImage -- Section Media
          imageWidth = 100.w;
          imageHeight = 25.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet SinlgeImage -- Section Media
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          //Web SinlgeImage -- Section Media
          if (globalConstraints.maxWidth < 600) {
            imageWidth = 100.w;
            imageHeight = 25.h;

            /// 4;
          } else if (globalConstraints.maxWidth < 1230) {
            imageWidth = 100.w;
            imageHeight = 25.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 50.h;
          }
        }
      } else {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile multiple Media -- Section Media
          imageWidth = 100.w;
          imageHeight = 25.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet multiple Media -- Section Media
          imageWidth = 100.w;
          imageHeight = 40.h;
        } else {
          //Web multiple Media -- Section Media
          if (globalConstraints.maxWidth < 600) {
            imageWidth = 100.w;
            imageHeight = 25.h;
          } else if (globalConstraints.maxWidth < 1230) {
            imageWidth = 100.w;
            imageHeight = 25.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 40.h;
          }
        }
      }
      return [imageWidth, imageHeight];
    case ImageType.itemImage:
      if (isSingleImage) {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          imageWidth = 100.w;
          imageHeight = 26.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          //Web Single Media -- Item Media
          if (globalConstraints.maxWidth < 600) {
            imageWidth = 100.w;
            imageHeight = 26.h;
          } else if (globalConstraints.maxWidth < 1230) {
            imageWidth = 100.w;
            imageHeight = 30.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 50.h;
          }
        }
      } else {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile multiple Media -- Item Media
          imageWidth = 100.w;
          imageHeight = 26.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet multiple Media -- Item Media
          imageWidth = 100.w;
          imageHeight = 25.h;
        } else {
          //Web multiple Media -- Item Media
          if (globalConstraints.maxWidth < 600) {
            imageWidth = 100.w;
            imageHeight = 26.h;
          } else if (globalConstraints.maxWidth < 1230) {
            imageWidth = 100.w;
            imageHeight = 25.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 40.h;
          }
        }
      }
      return [imageWidth, imageHeight];
  }
}

List getColorAndIconForComment(CommentType commentType) {
  switch (commentType) {
    case CommentType.deficiency:
      return [ProjectColors.danger, "deficiency"];
    case CommentType.information:
      return [ProjectColors.firefly, "info"];
    case CommentType.notInspected:
      return [ProjectColors.firefly, "not_inspected"];
  }
}

// void expandedScrollToSections(index) {
//     print("expandedScrollToSections $index");
//      isExpanded[index] = !isExpanded[index];
// }
