import 'package:get/get.dart';
import 'package:test_webrtc/app/services/video_call.dart';

class InjectionDependency {
  static void init() {
    Get.put(VideoCallService());
  }
}
