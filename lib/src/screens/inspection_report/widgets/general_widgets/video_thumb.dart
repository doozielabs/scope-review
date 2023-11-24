import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class VideoThumb extends StatefulWidget {
  String videoAddress;
  BoxFit? fit;
  double? width;
  double? height;
  bool showVideoIcon;
  final Widget? errorBuilder;

  VideoThumb(
      {super.key,
      required this.videoAddress,
      this.errorBuilder,
      this.fit,
      this.height,
      this.width,
      this.showVideoIcon = false});

  @override
  State<VideoThumb> createState() => _VideoThumbState();
}

class _VideoThumbState extends State<VideoThumb> {
  bool thumbLoading = true;
  Uint8List? resultThumb;

  loadThumb() async {
    log("widget width: ${widget.width}");
    if (mounted) {
      try {
        resultThumb = await VideoThumbnail.thumbnailData(
          video:
              //  widget.imageShape != null
              //     ? widget.imageShape!.id.isHgui
              //         ? widget.imageShape!.url.envRelativePath()
              //         : widget.imageShape!.serverUrl!
              //     :
              widget.videoAddress,
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
                          ? Positioned(
                              bottom:
                                  // widget.height != null
                                  //     ? widget.height! / 50
                                  //     :
                                  10,
                              left:
                                  //  widget.width != null
                                  //     ? widget.width! / 50
                                  //     :
                                  10,
                              child: Container(
                                child: const Icon(
                                  CupertinoIcons.video_camera_solid,
                                  color: ProjectColors.aliceBlue,
                                  size:
                                      //  widget.width != null
                                      //     ? widget.width! / 2.8
                                      //     :
                                      40,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 25,
                                        color: Colors.black45,
                                        offset: Offset(0, 0))
                                  ],
                                ),
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
