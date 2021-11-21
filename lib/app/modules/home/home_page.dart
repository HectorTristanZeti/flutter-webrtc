import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/home/home_controller.dart';
import 'package:test_webrtc/app/modules/home/widgets/btn_accept_call.dart';
import 'package:test_webrtc/app/modules/home/widgets/btn_call_friend.dart';
import 'package:test_webrtc/app/modules/home/widgets/offer_answer_btn.dart';
import 'package:test_webrtc/app/modules/home/widgets/sdp_candidate_btn.dart';
import 'package:test_webrtc/app/modules/home/widgets/sdp_candidate_tf.dart';
import 'package:test_webrtc/app/modules/home/widgets/video_renders.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              VideoRenders(),
              ButtonCallFriend(),
              ButtonAcceptCall(),
              // OfferAndAnswerButtons(),
              // SdpcandidateTF(),
              // SdpCandidateButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
