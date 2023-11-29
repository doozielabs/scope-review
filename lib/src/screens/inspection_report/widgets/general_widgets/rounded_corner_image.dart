import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/video_thumb_web.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class ImageWithRoundedCorners extends StatelessWidget {
  final dynamic imageUrl;
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
      this.boxFit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double borderRadiusValue = (counts * 4.0);
    if (imageUrl is ImageShape) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child:
            GeneralHelper.imageHandlerForRoundedConner(imageUrl, width, height),
      );
    } else {
      return GeneralHelper.invalidImageText();
    }
  }
}

class ImageWithRoundedCornersV1 extends StatelessWidget {
  final dynamic imageUrl;
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
      this.boxFit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSizeValue = (counts * 10);
    double borderRadiusValue = (counts * 4.0);
    if (lastItem) {
      return GestureDetector(
        onTap: () async {
          if (kIsWeb) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomDialog(ids: ids!, media: media!)),
            );
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(ids: ids!, media: media!);
                });
          }
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            child: SizedBox(
                width: width,
                height: height,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: GeneralHelper.imageHandlerForGallery(imageUrl),
                //     // NetworkImage(
                //     //   baseUrlLive + imageUrl.original,
                //     // ),
                //     fit: BoxFit.cover,
                //     colorFilter: ColorFilter.mode(
                //         Colors.black.withOpacity(0.6), BlendMode.darken),
                //   ),
                // ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      child: GeneralHelper.isVideo(imageUrl.url)
                          ? VideoThumbWeb(
                              videoAddress: imageUrl.url,
                              fit: BoxFit.cover,
                              showVideoIcon: true,
                              height: height,
                              width: width,
                            )
                          : Image(
                              image: GeneralHelper.imageHandlerForGallery(
                                  imageUrl),
                              fit: BoxFit.cover,
                              color: Colors.black.withOpacity(0.6),
                            ),
                    ),
                    Positioned(
                        child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(
                              text: "+ $remain",
                              style: TextStyle(
                                  fontSize: fontSizeValue,
                                  color: Colors.white))),
                    ))
                  ],
                ))),
      );
    } else {
      if (imageUrl is ImageShape) {
        return GestureDetector(
            onTap: () async {
              if (kIsWeb) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomDialog(ids: ids!, media: media!)),
                );
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(ids: ids!, media: media!);
                    });
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              child: GeneralHelper.isVideo(imageUrl.url)
                  ? VideoThumbWeb(
                      fit: BoxFit.cover,
                      videoAddress: imageUrl.url,
                      showVideoIcon: true,
                      width: width,
                      height: height)
                  : GeneralHelper.imageHandlerForRoundedConner(
                      imageUrl, width, height),
            ));
      } else {
        return GeneralHelper.invalidImageText();
      }
    }
  }
}

class ImageWithRoundedCornersForHeader extends StatelessWidget {
  final dynamic imageUrl;
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
      this.boxFit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSizeValue = (counts * 10);
    double borderRadiusValue = 16.0;
    if (lastItem) {
      return GestureDetector(
          onTap: () async {
            if (kIsWeb) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CustomDialog(ids: ids!, media: media!)),
              );
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(ids: ids!, media: media!);
                  });
            }
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return CustomDialog(ids: ids!, media: media!);
            //     });
          },
          child: (imageUrl is ImageShape)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: GeneralHelper.imageHandlerForGallery(imageUrl),
                        // NetworkImage(
                        //   baseUrlLive + imageUrl.original,
                        // ),
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
                )
              : const SizedBox());
    } else {
      if (imageUrl is ImageShape) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          child: GeneralHelper.imageHandlerForRoundedConner(
              imageUrl, width, height),
        );
      } else {
        return GeneralHelper.invalidImageText();
      }
    }
  }
}
