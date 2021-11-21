import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/home/home_binding.dart';
import 'package:test_webrtc/app/modules/home/home_page.dart';
import 'package:test_webrtc/app/modules/user/user_binding.dart';
import 'package:test_webrtc/app/modules/user/user_page.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const UserPage(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
