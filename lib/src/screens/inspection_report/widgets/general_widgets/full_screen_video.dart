import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/video_viewer.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart';

class FullScreenVideo extends StatefulWidget {
  String videoPath;
  FullScreenVideo({super.key, required this.videoPath});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  void goFullScreen() {
    document.documentElement!.requestFullscreen();
  }

  void exitFullScreen() {
    document.exitFullscreen();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (kIsWeb) {
      document.addEventListener('fullscreenchange', (event) {
        log("event phase: ${event.eventPhase}");
        log("fullScreenChange");
        if (document.fullscreenElement == null) {
          if (kDebugMode) {
            log('Video fullscreen exit');
            Navigator.of(context).pop();
          }
        } else {
          if (kDebugMode) {
            log('Video fullscreen enter');
          }
        }
      }, false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    log("dispose called");

    document.removeEventListener("fullscreenchange", (event) => null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 100.h,
            width: 100.w,
            color: Colors.black,
            child: VideoViewer(address: widget.videoPath),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: CupertinoButton(
                  child: const Icon(
                    Icons.fullscreen_exit,
                    color: ProjectColors.white,
                  ),
                  onPressed: () {
                    if (kIsWeb) {
                      document.exitFullscreen();
                    }
                    //Navigator.of(context).pop();
                  }))
        ],
      ),
    );
  }
}
