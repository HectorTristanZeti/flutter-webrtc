import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/user/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}
