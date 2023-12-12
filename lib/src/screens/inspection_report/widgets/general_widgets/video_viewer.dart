import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:device_real_orientation/device_orientation.dart' as dro;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  String address;
  double height;
  double width;
  bool showPlayVideo;
  Enum orientation;
  VideoViewer(
      {super.key,
      required this.address,
      this.showPlayVideo = true,
      this.height = 15,
      this.orientation = dro.DeviceOrientation.portrait,
      this.width = 15});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  double _currentPos = 0.0;

  final Key _key = const Key("1");

  @override
  void initState() {
    super.initState();

    log(imgBaseUrl + widget.address);
    if (kIsWeb) {
      _controller = VideoPlayerController.network(imgBaseUrl + widget.address)
        ..initialize().then((value) {
          _controller.setLooping(true);
          setState(() {});
        });
    } else if (widget.address.isUrl || widget.address.contains("https")) {
      _controller = VideoPlayerController.networkUrl(Uri(path: widget.address))
        ..initialize().then((value) {
          _controller.setLooping(true);
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.file(File(widget.address))
        ..initialize().then((value) {
          _controller.setLooping(true);
          setState(() {});
        });
    }

    _controller.addListener(() {
      setState(() {
        getCurrentPos();
      });
    });
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  getCurrentPos() async {
    _currentPos = _controller.value.position.inSeconds /
        _controller.value.duration.inSeconds;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Widget videoControlBar() {
    return SizedBox(
      width: isTablet
          ? 100.w
          : widget.orientation == dro.DeviceOrientation.landscapeLeft
              ? 100.h
              : 100.w,
      height: 100.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: isTablet
                ? 100.w
                : widget.orientation == dro.DeviceOrientation.landscapeLeft
                    ? 100.h
                    : 100.w,
            height: 8.h,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.h),
                        color: Colors.black.withOpacity(0.3),
                        width: isTablet
                            ? 70.w
                            : widget.orientation ==
                                    dro.DeviceOrientation.landscapeLeft
                                ? 70.h
                                : 70.w,
                        // margin: EdgeInsets.symmetric(horizontal: 10.hs),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                _printDuration(_controller.value.position),
                                style: const TextStyle(
                                    color: ProjectColors.white,
                                    fontFamily: "jost-Regular",
                                    fontSize: 14),
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                  trackHeight: 2,
                                ),
                                child: Slider(
                                  value: _controller
                                      .value.position.inMilliseconds
                                      .toDouble(),
                                  max: _controller.value.duration.inMilliseconds
                                      .toDouble(),
                                  onChanged: (x) {
                                    // logWarning(x.toString());
                                    // int ms =
                                    //     ((_controller.value.duration.inMilliseconds *
                                    //                 x) /
                                    //             100)
                                    //         .round();

                                    _controller.seekTo(
                                        Duration(milliseconds: x.round()));
                                  },
                                  activeColor: ProjectColors.white,
                                  inactiveColor:
                                      ProjectColors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                _printDuration(_controller.value.duration),
                                style: const TextStyle(
                                    color: ProjectColors.white,
                                    fontFamily: "jost-Regular",
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Center(
            child: _controller.value.isInitialized
                ? widget.showPlayVideo == false
                    ? VideoPlayer(_controller)
                    : AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                : Container(),
          ),
        ),
        Center(
            child: widget.showPlayVideo
                ? !(_controller.value.isPlaying)
                    ? CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        minSize: 0.0001,
                        onPressed: () async {
                          // bool playbackState =
                          //     await _videoTrimmers[videoTrimmerRef['$index']!].videoPlaybackControl(
                          //   startValue: _startValue,
                          //   endValue: _endValue,
                          // );
                          // setState(() {
                          //  // _isPlaying = playbackState;
                          // });
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                            setState(() {});
                          } else {
                            _controller.play();
                            setState(() {});
                          }
                          // _controller.
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: ProjectColors.black.withOpacity(0.4),
                          ),
                          child: const Icon(
                            // _controller.value.isPlaying
                            //     ? Icons.pause
                            //     :
                            Icons.play_arrow,
                            color: ProjectColors.white,
                            size: 60,
                          ),
                        ))
                    : Container()
                : Container()),
        widget.showPlayVideo == false
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
            : Container(),
        GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
                setState(() {});
              } else {
                _controller.play();

                setState(() {});
              }
            },
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
            )),
        Positioned(bottom: kIsWeb ? 12.h : 10.h, child: videoControlBar()),
      ],
    );
  }
}
