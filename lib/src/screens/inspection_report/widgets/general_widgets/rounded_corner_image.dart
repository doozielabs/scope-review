import 'package:flutter/material.dart';
// import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class ImageWithRoundedCorners extends StatelessWidget {
  final ImageShape imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit boxFit;
  final int counts;

  const ImageWithRoundedCorners(
      {Key? key,
      required this.imageUrl,
      this.width = 300,
      this.height = 300,
      this.borderRadius = 16.0,
      this.counts = 0,
      this.boxFit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double borderRadiusValue = (counts * 4.0);
    print("GettingLinkUrl:${imageUrl.url}");
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: (!(imageUrl.url).isDeviceUrl ||
              !(imageUrl.url)
                  .isAsset) //getDeviceType(context) == DeviceTypeForWeb.web
          ? Image.network(
              baseUrlLive + imageUrl.original,
              width: width,
              height: height,
              fit: BoxFit.fill,
            )
          : Image.asset(
              imageUrl.url,
              width: width,
              height: height,
              fit: BoxFit.fill,
            ),
    );
  }
}

class ImageWithRoundedCornersV1 extends StatelessWidget {
  final ImageShape imageUrl;
  final double width;
  final double height;
  final int remain;
  final double borderRadius;
  final BoxFit boxFit;
  final bool lastItem;
  final int counts;
  final List<String>? ids;
  final List<ImageShape>? media;

  const ImageWithRoundedCornersV1(
      {Key? key,
      required this.imageUrl,
      this.width = 300,
      this.height = 300,
      required this.remain,
      this.counts = 0,
      this.lastItem = false,
      this.borderRadius = 16.0,
      this.ids,
      this.media,
      this.boxFit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSizeValue = (counts * 10);
    double borderRadiusValue = (counts * 4.0);
    if (lastItem) {
      return GestureDetector(
        onTap: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(ids: ids!, media: media!);
              });
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      baseUrlLive + imageUrl.original,
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(
                          text: "+ $remain",
                          style: TextStyle(
                              fontSize: fontSizeValue, color: Colors.white))),
                ))),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: (!(imageUrl.url).isDeviceUrl ||
                !(imageUrl.url)
                    .isAsset) //getDeviceType(context) == DeviceTypeForWeb.web
            ? Image.network(
                baseUrlLive + imageUrl.url,
                width: width,
                height: height,
                fit: BoxFit.fill,
              )
            : Image.asset(
                imageUrl.url,
                width: width,
                height: height,
                fit: BoxFit.fill,
              ),
      );
    }
  }
}

class ImageWithRoundedCornersForHeader extends StatelessWidget {
  final ImageShape imageUrl;
  final double width;
  final double height;
  final int remain;
  final double borderRadius;
  final BoxFit boxFit;
  final bool lastItem;
  final int counts;
  final List<String>? ids;
  final List<ImageShape>? media;

  const ImageWithRoundedCornersForHeader(
      {Key? key,
      required this.imageUrl,
      this.width = 300,
      this.height = 300,
      required this.remain,
      this.counts = 0,
      this.lastItem = false,
      this.borderRadius = 16.0,
      this.ids,
      this.media,
      this.boxFit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSizeValue = (counts * 10);
    double borderRadiusValue = 16.0; //(counts * 4.0);
    if (lastItem) {
      return GestureDetector(
          onTap: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(ids: ids!, media: media!);
                });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    baseUrlLive + imageUrl.original,
                  ),
                  fit: BoxFit.cover,
                  // colorFilter: ColorFilter.mode(
                  // Colors.black.withOpacity(0.6), BlendMode.darken),
                ),
                // fit: BoxFit.cover,
                // colorFilter: ColorFilter.mode(
                // Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
            // child: Align(
            //   alignment: Alignment.bottomRight,
            //   child: RichText(
            //       text: TextSpan(
            //           text: "+ $remain",
            //           style: TextStyle(
            //               fontSize: fontSizeValue, color: Colors.white))),
            // )
          ));
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: (!(imageUrl.url).isDeviceUrl ||
                !(imageUrl.url)
                    .isAsset) //getDeviceType(context) == DeviceTypeForWeb.web
            ? Image.network(
                baseUrlLive + imageUrl.url,
                width: width,
                height: height,
                fit: BoxFit.fill,
              )
            : Image.asset(
                imageUrl.url,
                width: width,
                height: height,
                fit: BoxFit.fill,
              ),
      );
    }
  }
}
