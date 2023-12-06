import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class VideoThumbWeb extends StatefulWidget {
  String videoAddress;
  BoxFit? fit;
  double? width;
  double? height;
  bool showVideoIcon;
  final Widget? errorBuilder;

  VideoThumbWeb(
      {super.key,
      required this.videoAddress,
      this.errorBuilder,
      this.fit,
      this.height,
      this.width,
      this.showVideoIcon = false});

  @override
  State<VideoThumbWeb> createState() => _VideoThumbWebState();
}

class _VideoThumbWebState extends State<VideoThumbWeb> {
  bool thumbLoading = true;
  Uint8List? resultThumb;
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    if (kIsWeb) {
      _controller = VideoPlayerController.network(baseUrl + widget.videoAddress)
        ..initialize().then((value) {
          setState(() {
            thumbLoading = false;
          });
        });
    } else if (widget.videoAddress.isUrl ||
        widget.videoAddress.contains("https")) {
      _controller = VideoPlayerController.network(widget.videoAddress)
        ..initialize().then((value) {
          setState(() {
            thumbLoading = false;
          });
        });
    } else if (widget.videoAddress.isDeviceUrl) {
      _controller = VideoPlayerController.file(File(widget.videoAddress))
        ..initialize().then((value) {
          setState(() {
            thumbLoading = false;
          });
        });
    } else {
      _controller = VideoPlayerController.network(baseUrl + widget.videoAddress)
        ..initialize().then((value) {
          setState(() {
            thumbLoading = false;
          });
        });
    }
    //}
    //);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    resultThumb = null;
    _controller.dispose();
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
                    color: Colors.grey,
                  ),
                ),
              )
            : SizedBox(
                width: widget.width, //Crop width
                height: widget.height,
                child: Stack(
                  children: [
                    SizedBox(
                      width: widget.width, //Crop width
                      height: widget.height, //Crop height
                      child: FittedBox(
                        // alignment: Alignment.center, //Move around the crop
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(
                              _controller,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.showVideoIcon,
                      child: Positioned(
                        bottom:
                            //    widget.height != null ? widget.height! / 50 :
                            10,
                        left:
                            //   widget.width != null ? widget.height! / 50 :
                            10,
                        child: Container(
                          child: const Icon(
                            CupertinoIcons.video_camera_solid,
                            color: ProjectColors.aliceBlue,
                            size:
                                //  widget.height != null
                                //     ? widget.height! / 2.8
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
                      ),
                    ),
                    Container(
                      width: widget.width,
                      height: widget.height,
                      color: Colors.transparent,
                    )
                  ],
                ),
              )

        // Icon(
        //     CupertinoIcons.exclamationmark_circle,
        //     color: ProjectColors.white,
        //   ),
        );
  }
}
