import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webRtc;
import 'package:sdp_transform/sdp_transform.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool _offer = false;
  webRtc.RTCPeerConnection? _peerConnection;
  webRtc.MediaStream? _localStream;
  final localRender = webRtc.RTCVideoRenderer();
  final remoteRender = webRtc.RTCVideoRenderer();
  final sdpController = TextEditingController();

  @override
  void onInit() {
    _initRenders();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
    super.onInit();
  }

  @override
  void onClose() {
    localRender.dispose();
    remoteRender.dispose();
    super.onClose();
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'}
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReciveAudio": true,
        "OfferToReciveVideo": true,
      },
      "optional": []
    };

    _localStream = await _getUserMedia();

    webRtc.RTCPeerConnection pc =
        await webRtc.createPeerConnection(configuration, offerSdpConstraints);

    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(
          json.encode(
            {
              'candidate': e.candidate.toString(),
              'sdpMid': e.sdpMid.toString(),
              'sdpMlineIndex': e.sdpMlineIndex,
            },
          ),
        );
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('add stream: ${stream.id}');
      remoteRender.srcObject = stream;
    };

    return pc;
  }

  void _initRenders() async {
    await localRender.initialize();
    await remoteRender.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };
    final stream =
        await webRtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
    localRender.srcObject = stream;
    return stream;
  }

  void createOffer() async {
    webRtc.RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp.toString());
    print(json.encode(session));
    _offer = true;
    Clipboard.setData(new ClipboardData(text: json.encode(session)));

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
    print(json.encode({
      'sdp': description.sdp.toString(),
      'type': description.type.toString(),
    }));

    _peerConnection!.setLocalDescription(description);
  }

  void setremoteDescription() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode(jsonString);
    String sdp = write(session, null);
    webRtc.RTCSessionDescription description = webRtc.RTCSessionDescription(
      sdp,
      _offer ? 'answer' : 'offer',
    );
    print(description.toMap());
    await _peerConnection!.setRemoteDescription(description);
  }

  void setCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode(jsonString);
    print(session['candidate']);
    dynamic candidate = webRtc.RTCIceCandidate(
      session['candidate'],
      session['sdpMid'],
      session['sdpMlineIndex'],
    );
    await _peerConnection!.addCandidate(candidate);
  }
}
