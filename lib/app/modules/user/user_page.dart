import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/user/user_controller.dart';

class UserPage extends GetView<UserController> {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona un usuario'),
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => controller.setUser1(),
              child: Text(
                'Usuario 1',
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.setUser2(),
              child: Text(
                'Usuario 2',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
