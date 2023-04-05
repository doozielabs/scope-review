import 'package:flutter/material.dart';
// import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class ImageWithRoundedCorners extends StatelessWidget {
  final String imageUrl;
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
    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: getDeviceType(context) == DeviceTypeForWeb.web
            ? Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: BoxFit.fill,
              )
            : Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: BoxFit.fill,
              ));
  }
}

class ImageWithRoundedCornersV1 extends StatelessWidget {
  final String imageUrl;
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
                      imageUrl,
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
        child: getDeviceType(context) == DeviceTypeForWeb.web
            ? Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: BoxFit.fill,
              )
            : Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: BoxFit.fill,
              ),
      );
    }
  }
}

class ImageWithRoundedCornersForHeader extends StatelessWidget {
  final String imageUrl;
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
                      imageUrl,
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
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
        child: getDeviceType(context) == DeviceTypeForWeb.web
            ? Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: BoxFit.fill,
              )
            : Image.asset(
                imageUrl,
                width: width,
                height: height,
                fit: BoxFit.fill,
              ),
      );
    }
  }
}

class ImageWithRoundedCornersV2 extends StatelessWidget {
  final List<String> imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit boxFit;

  const ImageWithRoundedCornersV2(
      {Key? key,
      required this.imageUrl,
      this.width = 300,
      this.height = 300,
      this.borderRadius = 16.0,
      this.boxFit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("swip-- ${imageUrl.length}");
    return Text("");
    //   return Swiper(
    // layout: SwiperLayout.STACK,
    // customLayoutOption:  CustomLayoutOption(
    //     startIndex: -1,
    //     stateCount: 3
    // ).addRotate([
    //   -45.0/180,
    //   0.0,
    //   45.0/180
    // ]).addTranslate([
    //   const Offset(-370.0, -40.0),
    //   const Offset(0.0, 0.0),
    //   const Offset(370.0, -40.0)
    // ]),
    // itemWidth: 300.0,
    // itemHeight: 200.0,
    // itemBuilder: (context, index) {
    //   return  Container(
    //     color: Colors.grey,
    //     child:  Center(
    //       child:  Image.network(
    //           imageUrl[index],
    // width: width,
    // height: height,
    // fit: BoxFit.fill,
    //         ),
    //     ),
    //   );
    // },
    // itemCount: imageUrl.length);

    // Swiper(
    //   itemCount: imageUrl.length,
    //   loop: true,
    //   scrollDirection: Axis.horizontal,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Padding(
    //       padding: const EdgeInsets.all(27.0),
    //       child:
    //       //getDeviceType(context) == DeviceType.web
    //       // ?
    //       Image.network(
    //         imageUrl[index],
    //         // width: width,
    //         // height: height,
    //         // fit: BoxFit.fill,
    //       ),
    //       // : Image.asset(
    //       //   imageUrl[index],
    //       // ),
    //     );
    //   },
    //   indicatorLayout: PageIndicatorLayout.COLOR,
    //   onIndexChanged: (index) {
    //     // playaudio(index);
    //   },
    //   autoplayDelay: 10000,
    //   autoplay: true,
    //   pagination: const SwiperPagination(),
    //   control: const SwiperControl(),
    // );
  }
}
