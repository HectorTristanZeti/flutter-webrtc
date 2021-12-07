// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_webrtc/app/modules/home/home_controller.dart';

// class TextStatuscall extends GetWidget<HomeController> {
//   const TextStatuscall({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: controller.readStreamCall(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           Map<String, dynamic> noteInfo =
//               snapshot.data!.docs[0].data()! as Map<String, dynamic>;
//           final statusCall = noteInfo['Status'].toString();
//           if (statusCall == 'Calling') {
//             // controller.initVideoCall();
//             return Container(
//               child: Text('En llamada'),
//             );
//           } else {
//             return Container(
//               child: Text(statusCall),
//             );
//           }
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }
