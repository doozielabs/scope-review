import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  String address;
  VideoViewer({super.key, required this.address});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  double _currentPos = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(baseUrl + widget.address);
    if (kIsWeb) {
      _controller =
          VideoPlayerController.networkUrl(Uri(path: baseUrl + widget.address))
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          ),
        ),
        Center(
            child: !(_controller.value.isPlaying)
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
                : Container()),
      ],
    );
  }
}
