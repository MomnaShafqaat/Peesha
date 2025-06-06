import 'package:cloud_firestore/cloud_firestore.dart';

class EmployerFirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addUserAda() async {
    final user = <String, dynamic>{
      "first": "Ada",
      "last": "Lovelace",
      "born": 1815,
    };

    await db.collection("users").add(user).then(
          (DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'),
    );
  }

  Future<void> addUserTuring() async {
    final user = <String, dynamic>{
      "first": "Alan",
      "middle": "Mathison",
      "last": "Turing",
      "born": 1912,
    };

    await db.collection("users").add(user).then(
          (DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'),
    );
  }

  Future<void> getAllUsers() async {
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }
}
