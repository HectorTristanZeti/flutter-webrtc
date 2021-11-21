import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/core/utils/injection_dependency.dart';
import 'package:test_webrtc/app/modules/routes/app_pages.dart';

void main() async {
  if (WebRTC.platformIsAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await Firebase.initializeApp();
  InjectionDependency.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
