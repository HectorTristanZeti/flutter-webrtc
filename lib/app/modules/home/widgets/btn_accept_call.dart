import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/home/home_controller.dart';

class ButtonAcceptCall extends GetWidget<HomeController> {
  const ButtonAcceptCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.joinRoom(),
      // onPressed: () => controller.acceptCall(),
      child: Text('Aceptar Llamada'),
    );

    // StreamBuilder<QuerySnapshot>(
    //   stream: controller.readStreamCall(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       Map<String, dynamic> noteInfo =
    //           snapshot.data!.docs[0].data()! as Map<String, dynamic>;
    //       final callingFriend = noteInfo['CallingBy'];
    //       if (callingFriend != null && callingFriend.isNotEmpty) {
    //         return ElevatedButton(
    //           onPressed: () => controller.joinRoom(),
    //           // onPressed: () => controller.acceptCall(),
    //           child: Text('Aceptar Llamada'),
    //         );
    //       } else {
    //         return Container();
    //       }
    //     } else {
    //       return Container();
    //     }
    //   },
    // );
  }
}
