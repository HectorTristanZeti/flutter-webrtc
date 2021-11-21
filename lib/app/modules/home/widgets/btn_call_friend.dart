import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/home/home_controller.dart';

class ButtonCallFriend extends GetWidget<HomeController> {
  const ButtonCallFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Icon(
        Icons.call,
      ),
      onPressed: () => controller.callingFriend(),
    );
  }
}
