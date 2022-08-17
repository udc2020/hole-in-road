import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FireBaseApi {
  static Future init() async {
    await Firebase.initializeApp();
  }

  static docUser(String collectionName) {
    return FirebaseFirestore.instance.collection(collectionName).doc();
  }
}
