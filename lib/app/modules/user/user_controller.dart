import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/routes/app_pages.dart';

class UserController extends GetxController {
  String user = '';

  void setUser1() {
    user = 'usuario1';
    Get.toNamed(Routes.home);
  }

  void setUser2() {
    user = 'usuario2';
    Get.toNamed(Routes.home);
  }
}
