import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/user/user_controller.dart';

class VideoCallService extends GetxService {
  final _firestore = FirebaseFirestore.instance;

  Future<String> getJsonOffer() async {
    final myNameUser = Get.find<UserController>().user;
    final _mainCollection = _firestore.collection(myNameUser);
    final userUid = myNameUser == 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final documentReferencer = _mainCollection.doc(userUid);
    final resp = await documentReferencer.get();
    print(resp.data()?['JsonOffer']);
    return resp.data()?['JsonOffer'];
  }

  Future<String> getJsonCandidate() async {
    final myNameUser = Get.find<UserController>().user;
    final _mainCollection = _firestore.collection(myNameUser);
    final userUid = myNameUser == 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final documentReferencer = _mainCollection.doc(userUid);
    final resp = await documentReferencer.get();
    print(resp.data()?['Candidate']);
    return resp.data()?['Candidate'];
  }

  Future<String> getJsonAnswer() async {
    final myNameUser = Get.find<UserController>().user;
    final _mainCollection = _firestore.collection(myNameUser);
    final userUid = myNameUser == 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final documentReferencer = _mainCollection.doc(userUid);
    final resp = await documentReferencer.get();
    final data = await resp.data();
    print(data?['JsonAnswer']);
    return data?['JsonAnswer'];
  }

  Future<void> updateStatusCallFriend(String statusCall) async {
    final myNameUser = Get.find<UserController>().user;
    // final userUid = myNameUser != 'usuario1'
    //     ? '4McMOFX6LGFGipUMZJ9a'
    //     : 'MnoveJN7PQHYnmKG2bmC';
    final nameUserFriend = myNameUser == 'usuario1' ? 'usuario2' : 'usuario1';
    final _mainCollection = _firestore.collection(nameUserFriend);
    final userFriendUid = myNameUser != 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    // final userFriendName = myNameUser != 'usuario1' ? 'usuario1' : 'usuario2';
    final documentReferencer = _mainCollection.doc(userFriendUid);

    await documentReferencer.set(
      {
        'Status': statusCall,
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> updateStatusCall(String statusCall) async {
    final myNameUser = Get.find<UserController>().user;
    final _mainCollection = _firestore.collection(myNameUser);
    final userUid = myNameUser == 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendUid = myNameUser != 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendName = myNameUser != 'usuario1' ? 'usuario1' : 'usuario2';
    final documentReferencer = _mainCollection.doc(userUid);

    await documentReferencer.set(
      {
        'Status': statusCall,
      },
      SetOptions(
        merge: true,
      ),
    );

    // final data = {
    //   'Status': statusCall,
    // };

    // await _addDataUserToFriend(userFriendName, userFriendUid, data);
  }

  Future<void> addJsonOffer(String myJsonOffer) async {
    final myNameUser = Get.find<UserController>().user;
    final _mainCollection = _firestore.collection(myNameUser);
    final userUid = myNameUser == 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendUid = myNameUser != 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendName = myNameUser != 'usuario1' ? 'usuario1' : 'usuario2';
    final documentReferencer = _mainCollection.doc(userUid);

    await documentReferencer.set(
      {
        'MyJsonOffer': myJsonOffer,
      },
      SetOptions(
        merge: true,
      ),
    );

    final data = {
      'JsonOffer': myJsonOffer,
      'CallingBy': myNameUser,
    };

    await _addDataUserToFriend(userFriendName, userFriendUid, data);
  }

  Future<void> addJsonAnswer(String myJsonAnswer) async {
    final myNameUser = Get.find<UserController>().user;

    final _mainCollection = _firestore.collection(myNameUser);
    final userUid = myNameUser == 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendUid = myNameUser != 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendName = myNameUser != 'usuario1' ? 'usuario1' : 'usuario2';
    final documentReferencer = _mainCollection.doc(userUid);

    await documentReferencer.set(
      {
        'MyJsonAnswer': myJsonAnswer,
      },
      SetOptions(
        merge: true,
      ),
    );

    final data = {
      'JsonAnswer': myJsonAnswer,
    };
    await _addDataUserToFriend(userFriendName, userFriendUid, data);
  }

  Future<void> addJsonCandidater(String candidate) async {
    final myNameUser = Get.find<UserController>().user;

    final _mainCollection = _firestore.collection(myNameUser);
    final userUid = myNameUser == 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendUid = myNameUser != 'usuario1'
        ? '4McMOFX6LGFGipUMZJ9a'
        : 'MnoveJN7PQHYnmKG2bmC';
    final userFriendName = myNameUser != 'usuario1' ? 'usuario1' : 'usuario2';
    final documentReferencer = _mainCollection.doc(userUid);

    await documentReferencer.set(
      {
        'MyCandidate': candidate,
      },
      SetOptions(
        merge: true,
      ),
    );

    final data = {
      'Candidate': candidate,
    };
    await _addDataUserToFriend(userFriendName, userFriendUid, data);
  }

  Stream<QuerySnapshot> readItems() {
    final myNameUser = Get.find<UserController>().user;
    final _mainCollection = _firestore.collection(myNameUser);
    // final userUid = myNameUser == 'usuario1'
    //     ? '4McMOFX6LGFGipUMZJ9a'
    //     : 'MnoveJN7PQHYnmKG2bmC';

    return _mainCollection.snapshots();
  }

  Future<void> _addDataUserToFriend(
    String nameUser,
    String userUid,
    Map<String, dynamic> data,
  ) async {
    final _mainCollection = _firestore.collection(nameUser);
    final documentReferencer = _mainCollection.doc(userUid);

    await documentReferencer.set(
      data,
      SetOptions(
        merge: true,
      ),
    );
  }
}
