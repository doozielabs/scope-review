import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_report_scope/pdf_report_scope.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:sizer/sizer.dart';

const baseUrlLive = 'https://api.scopeinspectapp.com/';
const baseUrlStaging = 'https://staging.scopeinspectapp.com/';
const baseUrlLocal = 'http://localhost:1337/';
const defaultHeaderImage1 = 'images/inspection_placeholder.png';
const defaultHeaderImage = "images/house.jpeg";
const defaultInvalidImage = "images/invalid-placholder.png";
String documentDirectory = "";

const double kMobileMaxWidth = 550.0;
const double kTabletMaxWidth = 959.0;
const double kDesktopMinWidth = 960.0;
const double headerHeight = 5000;
BoxConstraints globalConstraints = BoxConstraints();

final ScrollController mainListviewController = ScrollController();
final ScrollController sectionsListviewController = ScrollController();
final ScrollController sectionCommentsController = ScrollController();
final ScrollController subSectionsListviewController = ScrollController();
final ScrollController subSectionCommentsController = ScrollController();

Map<String, GlobalKey> itemKeys = {};
Map<String, GlobalKey> commentKeys = {};
bool isSummaryExpanded = false;
bool expandSummary = false;
const INVALID_IMAGE = "invalid image";
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

final isMobile =
    getDeviceType(NavigationService.navigatorKey.currentContext!) ==
        DeviceTypeForWeb.mobile;
final isTablet =
    getDeviceType(NavigationService.navigatorKey.currentContext!) ==
        DeviceTypeForWeb.tablet;
final isWeb = getDeviceType(NavigationService.navigatorKey.currentContext!) ==
    DeviceTypeForWeb.web;

final width =
    MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.width;
final height =
    MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.height;

DeviceTypeForWeb getDeviceType(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= kMobileMaxWidth) {
    return DeviceTypeForWeb.mobile;
  } else if (screenWidth <= kTabletMaxWidth) {
    return DeviceTypeForWeb.tablet;
  } else {
    return DeviceTypeForWeb.web;
  }
}

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

List getImageWidthHeight(ImageType imageType, List<dynamic>? images) {
  double imageWidth;
  double imageHeight;
  bool isSingleImage = images!.length == 1;
  switch (imageType) {
    case ImageType.commentImage:
      if (isSingleImage) {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile SinlgeImage -- Comment Image
          imageWidth = 100.w;
          imageHeight = 50.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet SinlgeImage -- Comment 
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          if(globalConstraints.maxWidth < 600){
            imageWidth = 100.w;
            imageHeight = 50.h;
          } else if(globalConstraints.maxWidth < 1230){
            imageWidth = 100.w;
            imageHeight = 25.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 50.h;
          }
          
        }
      } else {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile multiple Images -- Comment Image
          imageWidth = 100.w;
          imageHeight = 40.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet multiple Images -- Comment Image
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          //Web multiple Images -- Comment Image
          if(globalConstraints.maxWidth < 600){
            imageWidth = 100.w;
            imageHeight = 40.h;
          } else if(globalConstraints.maxWidth < 1230){
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
          //Mobile SinlgeImage -- Section Image
          imageWidth = 100.w;
          imageHeight = 50.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet SinlgeImage -- Section Image
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          //Web SinlgeImage -- Section Image
          if(globalConstraints.maxWidth < 600){
            imageWidth = 100.w;
            imageHeight = 50.h; /// 4;
          } else if(globalConstraints.maxWidth < 1230){
            imageWidth = 100.w;
            imageHeight = 25.h;
          } else {
            imageWidth = 100.w;
            imageHeight = 50.h;
          }
        }
      } else {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile multiple Images -- Section Image
          imageWidth = 100.w;
          imageHeight = 40.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet multiple Images -- Section Image
          imageWidth = 100.w;
          imageHeight = 40.h;
        } else {
          //Web multiple Images -- Section Image
          if(globalConstraints.maxWidth < 600){
            imageWidth = 100.w;
            imageHeight = 40.h;
          } else if(globalConstraints.maxWidth < 1230){
            imageWidth = 100.w;
            imageHeight = 40.h;
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
          imageHeight = 50.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          imageWidth = 100.w;
          imageHeight = 30.h;
        } else {
          //Web Single Images -- Item Image
          if(globalConstraints.maxWidth < 600){
             imageWidth = 100.w;
            imageHeight = 50.h;
          } else if(globalConstraints.maxWidth < 1230){
             imageWidth = 100.w;
            imageHeight = 30.h;
          } else {
             imageWidth = 100.w;
            imageHeight = 50.h;
          }
        }
      } else {
        if (SizerUtil.deviceType == DeviceType.mobile) {
          //Mobile multiple Images -- Item Image
          imageWidth = 100.w;
          imageHeight = 40.h;
        } else if (SizerUtil.deviceType == DeviceType.tablet) {
          //Tablet multiple Images -- Item Image
          imageWidth = 100.w;
          imageHeight = 25.h;
        } else {
          //Web multiple Images -- Item Image
          if(globalConstraints.maxWidth < 600){
            imageWidth = 100.w;
            imageHeight = 40.h;
          } else if(globalConstraints.maxWidth < 1230){
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
