import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webRtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/user/user_controller.dart';
import 'package:test_webrtc/app/services/video_call.dart';
import 'package:test_webrtc/signaling.dart';

class HomeController extends GetxController {
  final _videoCallService = Get.find<VideoCallService>();

  webRtc.RTCPeerConnection? _peerConnection;

  MediaStream? _localStream;
  MediaStream? _remoteStream;

  StreamStateCallback? onAddRemoteStream;

  final localRender = webRtc.RTCVideoRenderer();
  final remoteRender = webRtc.RTCVideoRenderer();

  final sdpController = TextEditingController();

  RxBool isShowLocalVideo = false.obs;
  RxBool isShowRemoteVideo = false.obs;
  bool _offer = false;

  String myJsonOffer = '';
  String myJsonAnswer = '';
  String myCandidate = '';

  String? roomId;
  String? currentRoomText;

  get userName => Get.find<UserController>().user;

  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  @override
  void onInit() {
    // _initRenders();
    // _createPeerConnection().then((pc) {
    //   _peerConnection = pc;
    // });
    localRender.initialize();
    remoteRender.initialize();

    onAddRemoteStream = ((stream) {
      remoteRender.srcObject = stream;
      isShowRemoteVideo.value = true;
    });
    super.onInit();
  }

  @override
  void onReady() {
    Future.delayed(Duration(seconds: 5)).then((_) => openUserMedia());
    super.onReady();
  }

  @override
  void onClose() {
    localRender.dispose();
    remoteRender.dispose();
    super.onClose();
  }

  Future<void> openUserMedia() async {
    var stream = await webRtc.navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});

    localRender.srcObject = stream;
    _localStream = stream;

    remoteRender.srcObject = await createLocalMediaStream('key');

    isShowLocalVideo.value = true;
  }

  Future<String> createRoom() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('1234');

    print('Create PeerConnection with configuration: $configuration');

    _peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    // Code for collecting ICE candidates below
    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print('Got candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap());
    };
    // Finish Code for collecting ICE candidate

    // Add code for creating a room
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    print('Created offer: $offer');

    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;
    print('New room created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        _remoteStream?.addTrack(track);
      });
    };

    // Listening for remote session description below
    roomRef.snapshots().listen((snapshot) async {
      print('Got updated room: ${snapshot.data()}');

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (_peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        print("Someone tried to connect");
        await _peerConnection?.setRemoteDescription(answer);
      }
    });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          print('Got new remote ICE candidate: ${jsonEncode(data)}');
          _peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    });
    // Listen for remote ICE candidates above

    return roomId;
  }

  Future<void> joinRoom() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('1234');
    var roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      _peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      _peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream: $track');
          _remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('Got offer $data');
      var offer = data['offer'];
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await _peerConnection!.createAnswer();
      print('Created Answer $answer');

      await _peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Got new remote ICE candidate: $data');
          _peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }

  void registerPeerConnectionListeners() {
    _peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    _peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    _peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    _peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    _peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      _remoteStream = stream;
    };
  }

  /// old code

  // _createPeerConnection() async {
  //   Map<String, dynamic> configuration = {
  //     'iceServers': [
  //       {'url': 'stun:stun.kotter.net:3478'}
  //     ]
  //   };

  //   final Map<String, dynamic> offerSdpConstraints = {
  //     "mandatory": {
  //       "OfferToReciveAudio": true,
  //       "OfferToReciveVideo": true,
  //     },
  //     "optional": []
  //   };

  //   _localStream = await _getUserMedia();

  //   webRtc.RTCPeerConnection pc =
  //       await webRtc.createPeerConnection(configuration, offerSdpConstraints);

  //   pc.addStream(_localStream!);

  //   pc.onIceCandidate = (e) async {
  //     if (e.candidate != null) {
  //       print(
  //         json.encode(
  //           {
  //             'candidate': e.candidate.toString(),
  //             'sdpMid': e.sdpMid.toString(),
  //             'sdpMlineIndex': e.sdpMlineIndex,
  //           },
  //         ),
  //       );
  //       if (myCandidate.isEmpty) {
  //         myCandidate = json.encode(
  //           {
  //             'candidate': e.candidate.toString(),
  //             'sdpMid': e.sdpMid.toString(),
  //             'sdpMlineIndex': e.sdpMlineIndex,
  //           },
  //         );
  //         await _videoCallService.addJsonCandidater(myCandidate);
  //         print('canditato');
  //       }
  //     }
  //   };

  //   pc.onIceConnectionState = (e) {
  //     print(e);
  //   };

  //   pc.onAddStream = (stream) {
  //     print('add stream: ${stream.id}');
  //     remoteRender.srcObject = stream;
  //     isShowRemoteVideo.value = true;
  //   };

  //   return pc;
  // }

  // void _initRenders() async {
  //   await localRender.initialize();
  //   await remoteRender.initialize();
  //   _getUserMedia();
  // }

  // Future<webRtc.MediaStream> _getUserMedia() async {
  //   final Map<String, dynamic> mediaConstraints = {
  //     'audio': true,

  //     ///TODO; ponerlo en true despues de pruebas
  //     'video': {
  //       'facingMode': 'user',
  //     },
  //   };
  //   final stream =
  //       await webRtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
  //   localRender.srcObject = stream;
  //   isShowLocalVideo.value = true;
  //   return stream;
  // }

  // Future<void> callingFriend() async {
  //   /// Pega el json offer a firebase
  //   await createOffer();
  //   await _videoCallService.addJsonOffer(myJsonOffer);
  //   await updateStatusCall('Llamada en pendiente en contestar');
  // }

  // Future<void> acceptCall() async {
  //   ///se asigna el json offer y se pega el json answer a firebase
  //   try {
  //     final jsonOffer = await _videoCallService.getJsonOffer();
  //     await setremoteDescription(jsonOffer);
  //     await Future.delayed(Duration(seconds: 3));
  //     await createAnswer();
  //     await _videoCallService.addJsonAnswer(myJsonAnswer);

  //     await updateStatusCallFriend('Calling');
  //   } catch (e) {
  //     print('error en aceptar llamada $e');
  //   }
  // }

  // Future<void> initVideoCall() async {
  //   // try {
  //   //   final jsonAnswer = await _videoCallService.getJsonAnswer();
  //   //   await setremoteDescription(jsonAnswer);
  //   //   final jsonCandidate = await _videoCallService.getJsonCandidate();
  //   //   await setCandidate(jsonCandidate);
  //   //   print('en llamada');
  //   // } catch (e) {
  //   //   print('error en init llamada $e');
  //   // }
  // }

  // Stream<QuerySnapshot<Object?>> readStreamCall() =>
  //     _videoCallService.readItems();

  // Future<void> updateStatusCall(String status) async {
  //   await _videoCallService.updateStatusCall(status);
  // }

  // Future<void> updateStatusCallFriend(String status) async {
  //   await _videoCallService.updateStatusCallFriend(status);
  // }

  // Future<void> createOffer() async {
  //   webRtc.RTCSessionDescription description =
  //       await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
  //   var session = parse(description.sdp.toString());
  //   print(json.encode(session));
  //   myJsonOffer = json.encode(session);
  //   _offer = true;
  //   Clipboard.setData(new ClipboardData(text: json.encode(session)));

  //   // print(json.encode({
  //   //       'sdp': description.sdp.toString(),
  //   //       'type': description.type.toString(),
  //   //     }));

  //   _peerConnection!.setLocalDescription(description);
  // }

  // Future<void> createAnswer() async {
  //   webRtc.RTCSessionDescription description =
  //       await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

  //   var session = parse(description.sdp.toString());
  //   myJsonAnswer = json.encode(session);
  //   print(json.encode(session));
  //   print(json.encode({
  //     'sdp': description.sdp.toString(),
  //     'type': description.type.toString(),
  //   }));

  //   _peerConnection!.setLocalDescription(description);
  // }

  // Future<void> setremoteDescription(String jsonString) async {
  //   // String jsonString = sdpController.text;
  //   dynamic session = await jsonDecode(jsonString);
  //   String sdp = write(session, null);
  //   webRtc.RTCSessionDescription description = webRtc.RTCSessionDescription(
  //     sdp,
  //     _offer ? 'answer' : 'offer',
  //   );
  //   print(description.toMap());
  //   await _peerConnection!.setRemoteDescription(description);
  // }

  // Future<void> setCandidate(String jsonString) async {
  //   // String jsonString = sdpController.text;
  //   dynamic session = await jsonDecode(jsonString);
  //   print(session['candidate']);
  //   dynamic candidate = webRtc.RTCIceCandidate(
  //     session['candidate'],
  //     session['sdpMid'],
  //     session['sdpMlineIndex'],
  //   );
  //   print('antes de peerconnectio');
  //   await _peerConnection!.addCandidate(candidate);
  //   print('despues de peerconnectio');
  // }
}
