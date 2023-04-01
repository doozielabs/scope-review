import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/main.dart';
import 'package:sizer/sizer.dart';

const baseUrlLive = 'https://api.scopeinspectapp.com';
const baseUrlStaging = 'https://staging.scopeinspectapp.com';
const baseUrlLocal = 'http://localhost:1337/';
const defaultHeaderImage1 = 'assets/images/inspection_placeholder.png';
const defaultHeaderImage = "assets/images/house.jpeg";

const double kMobileMaxWidth = 550.0;
const double kTabletMaxWidth = 959.0;
const double kDesktopMinWidth = 960.0;

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

List getImageWidthHeight(ImageType imageType, List<dynamic>? images) {
  double imageWidth;
  double imageHeight;
  bool isSingleImage = images!.length == 1;
  switch (imageType) {
    case ImageType.commentImage:
      if (isSingleImage) {
        if (isMobile) {
          //Mobile SinlgeImage -- Comment Image
          imageWidth = width;
          imageHeight = height / 5;
        } else if (isTablet) {
          //Tablet SinlgeImage -- Comment Image
          imageWidth = width;
          imageHeight = height / 3;
        } else {
          //Web SinlgeImage -- Comment Image
          imageWidth = width / 3;
          imageHeight = height / 4;
        }
      } else {
        if (isMobile) {
          //Mobile multiple Images -- Comment Image
          imageWidth = width / 2.5;
          imageHeight = height / 5.5;
        } else if (isTablet) {
          //Tablet multiple Images -- Comment Image
          imageWidth = width;
          imageHeight = height / 4;
        } else {
          //Web multiple Images -- Comment Image
          imageWidth = width / 9.3;
          imageHeight = width / 9.4;
        }
      }
      return [imageWidth, imageHeight];
    case ImageType.sectionImage:
      if (isSingleImage) {
        if (isMobile) {
          //Mobile SinlgeImage -- Section Image
          imageWidth = width;
          imageHeight = height;
        } else if (isTablet) {
          //Tablet SinlgeImage -- Section Image
          imageWidth = width * 0.50;
          imageHeight = height;
        } else {
          //Web SinlgeImage -- Section Image
          imageWidth = width;
          imageHeight = height;
        }
      } else {
        if (isMobile) {
          //Mobile multiple Images -- Section Image
          imageWidth = width;
          imageHeight = height / 4;
        } else if (isTablet) {
          //Tablet multiple Images -- Section Image
          imageWidth = width;
          imageHeight = height / 5;
        } else {
          //Web multiple Images -- Section Image
          imageWidth = width;
          imageHeight = height / 4;
        }
      }
      return [imageWidth, imageHeight];
    case ImageType.itemImage:
      if (isSingleImage) {
        if (isMobile) {
          imageWidth = width;
          imageHeight = height / 4;
        } else if (isTablet) {
          imageWidth = width;
          imageHeight = width / 5;
        } else {
          //Web Single Images -- Item Image
          imageWidth = width;
          imageHeight = height / 5;
        }
      } else {
        if (isMobile) {
          //Mobile multiple Images -- Item Image
          imageWidth = width / 2.5;
          imageHeight = height / 5.5;
        } else if (isTablet) {
          //Tablet multiple Images -- Item Image
          imageWidth = width / 4.9;
          imageHeight = width / 4.9;
        } else {
          //Web multiple Images -- Item Image
          imageWidth = width / 13;
          imageHeight = height / 10;
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
