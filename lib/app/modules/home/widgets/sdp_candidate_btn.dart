import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/home/home_controller.dart';

class SdpCandidateButtons extends GetWidget<HomeController> {
  const SdpCandidateButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: controller.setremoteDescription,
          child: Text(
            'set remote desc',
          ),
          // style: ,
        )
      ],
    );
  }
}
