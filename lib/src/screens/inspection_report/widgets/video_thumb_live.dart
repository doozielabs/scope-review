import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class VideoThumbLive extends StatefulWidget {
  String path;
  BoxFit? fit;
  double? width;
  double? height;
  bool showVideoIcon;
  final Widget? errorBuilder;

  VideoThumbLive(
      {super.key,
      required this.path,
      this.errorBuilder,
      this.fit,
      this.height,
      this.width,
      this.showVideoIcon = false});

  @override
  State<VideoThumbLive> createState() => _VideoThumbLiveState();
}

class _VideoThumbLiveState extends State<VideoThumbLive> {
  bool thumbLoading = true;
  Uint8List? resultThumb;

  loadThumb() async {
    if (mounted) {
      log(widget.path);
      try {
        resultThumb = await VideoThumbnail.thumbnailData(
          video: widget.path.isDeviceUrl ? widget.path : baseUrl + widget.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth:
              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 50,
        );
      } catch (e) {
        if (kDebugMode) {
          log(e.toString());
        }
      } finally {
        if (mounted) {
          setState(() {
            thumbLoading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadThumb();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    resultThumb = null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: thumbLoading
            ? const Padding(
                padding: EdgeInsetsDirectional.all(5),
                child: Center(
                  child: CupertinoActivityIndicator(
                    color: ProjectColors.white,
                  ),
                ),
              )
            : resultThumb != null
                ? Stack(
                    children: [
                      Image.memory(
                        resultThumb!,
                        fit: widget.fit,
                        width: widget.width,
                        height: widget.height,
                      ),
                      widget.showVideoIcon
                          ? const Positioned(
                              bottom: 5,
                              // widget.height != null
                              //     ? widget.height! / 50
                              //     : 10,
                              left: 5,
                              // widget.width != null
                              //     ? widget.width! / 50
                              //     : 10,
                              child: Icon(
                                CupertinoIcons.video_camera_solid,
                                color: ProjectColors.aliceBlue,
                                // size: 40,
                                // (widget.width != null
                                //     ? widget.width! / 2.8
                                //     : 20)
                                //     ,
                                shadows: [
                                  Shadow(
                                      blurRadius: 25,
                                      color: Colors.black45,
                                      offset: Offset(0, 0))
                                ],
                              ),
                            )
                          : Container()
                    ],
                  )
                : widget.errorBuilder
        // Icon(
        //     CupertinoIcons.exclamationmark_circle,
        //     color: ProjectColors.white,
        //   ),
        );
  }
}
