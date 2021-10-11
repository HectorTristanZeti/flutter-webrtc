import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webRtc;
import 'package:sdp_transform/sdp_transform.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool _offer = false;
  webRtc.RTCPeerConnection? _peerConnection;
  webRtc.MediaStream? _localStream;
  final localRender = webRtc.RTCVideoRenderer();
  final remoteRender = webRtc.RTCVideoRenderer();

  @override
  void onInit() {
    _initRenders();
    _getUserMedia();
    super.onInit();
  }

  @override
  void onClose() {
    localRender.dispose();
    remoteRender.dispose();
    super.onClose();
  }

  void _initRenders() async {
    await localRender.initialize();
    await remoteRender.initialize();
  }

  void _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {'facingMode': 'user'}
    };
    final stream =
        await webRtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
    localRender.srcObject = stream;
  }

   void createOffer() async {
    webRtc.RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp.toString());
    print(json.encode(session));
    _offer = true;

    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    _peerConnection!.setLocalDescription(description);
  }

   void createAnswer() async {
    webRtc.RTCSessionDescription description =
        await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp.toString());
    print(json.encode(session));
    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    _peerConnection!.setLocalDescription(description);
  }

  void setremoteDescription(){
    
  }
}
