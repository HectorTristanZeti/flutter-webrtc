import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:test_webrtc/app/modules/user/user_controller.dart';

class VideoCallService extends GetxService {
  final _firestore = FirebaseFirestore.instance;

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

  Future<void> addJsonAnswer(String myJsonOffer, String candidate) async {
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
        'MyJsonAnswer': myJsonOffer,
        'MyCandidate': candidate,
      },
      SetOptions(
        merge: true,
      ),
    );

    final data = {
      'JsonAnswer': myJsonOffer,
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
