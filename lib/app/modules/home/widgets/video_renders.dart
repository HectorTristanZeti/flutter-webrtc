import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/home/home_controller.dart';

class VideoRenders extends GetWidget<HomeController> {
  const VideoRenders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Row(
        children: [
          Flexible(
            child: Container(
              key: Key('local'),
              margin: EdgeInsets.fromLTRB(
                5,
                5,
                5,
                5,
              ),
              decoration: BoxDecoration(color: Colors.black),
              child: RTCVideoView(
                controller.localRender,
              ),
            ),
          ),
          Flexible(
            child: Container(
              key: Key('remote'),
              margin: EdgeInsets.fromLTRB(
                5,
                5,
                5,
                5,
              ),
              decoration: BoxDecoration(color: Colors.black),
              child: RTCVideoView(
                controller.remoteRender,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
