import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:device_real_orientation/device_orientation.dart' as dro;
import 'package:device_real_orientation/device_orientation_provider.dart'
    as dop;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  String address;
  double heighta;
  double widtha;
  bool showPlayVideo;
  dro.DeviceOrientation orientation;
  VideoViewer(
      {super.key,
      required this.address,
      this.showPlayVideo = true,
      this.heighta = 15,
      this.orientation = dro.DeviceOrientation.portrait,
      this.widtha = 15});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  double _currentPos = 0.0;
  dro.DeviceOrientation orientation = dro.DeviceOrientation.portrait;

  final Key _key = const Key("1");

  getOrientation() async {
    orientation = widget.orientation;
  }

  @override
  void initState() {
    super.initState();
    getOrientation();
    dop.DeviceOrientationProvider.orientations.listen((orientation) {
      setState(() {
        this.orientation = orientation;
      });
    });

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
      _controller =
          VideoPlayerController.file(File(widget.address.envRelativePath()))
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

  Widget videoControlBar(double height, double width) {
    return SizedBox(
      width: isTablet
          ? width
          : orientation == dro.DeviceOrientation.landscapeLeft
              ? height
              : width,
      height: height * 0.06,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
              color: Colors.black.withOpacity(0.3),
              width: isTablet
                  ? width * 0.7
                  : widget.orientation == dro.DeviceOrientation.landscapeLeft
                      ? height * 0.7
                      : width * 0.85,
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
                        value: _controller.value.position.inMilliseconds
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

                          _controller.seekTo(Duration(milliseconds: x.round()));
                        },
                        activeColor: ProjectColors.white,
                        inactiveColor: ProjectColors.white.withOpacity(0.5),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    log("height: $height, width: $width");
    return Stack(
      children: [
        SizedBox(
            //height: height * 0.8,
            //width: width,
            child: Center(
          child: _controller.value.isInitialized
              ? widget.showPlayVideo == false
                  ? VideoPlayer(_controller)
                  : AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller))
              : Container(),
        )),
        Center(
            child: widget.showPlayVideo
                ? !(_controller.value.isPlaying)
                    ? CupertinoButton(
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
                            //setState(() {});
                          } else {
                            _controller.play();
                            //setState(() {});
                          }
                          // _controller.
                        },
                        child: Container(
                          height: height * 0.07,
                          width: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: ProjectColors.black.withOpacity(0.4),
                          ),
                          child: Center(
                            child: Icon(
                              // _controller.value.isPlaying
                              //     ? Icons.pause
                              //     :
                              Icons.play_arrow,
                              color: ProjectColors.white,
                              size: height * 0.05,
                            ),
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
        Positioned(
            bottom: kIsWeb || isTablet
                ? height * 0.05
                : orientation == dro.DeviceOrientation.landscapeLeft
                    ? width * 0.05
                    : height * 0.05,
            left: 10,
            right: 10,
            child: videoControlBar(height, width)),
      ],
    );
  }
}
