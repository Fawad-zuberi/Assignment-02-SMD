import 'package:assignment2/Model/UserDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService(this._auth, this._firestore);

  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<Userdatamodel?> getUserData(String uid) async {
    final userDoc = await _firestore.collection('User').doc(uid).get();
    if (userDoc.exists) {
      return Userdatamodel.fromJson(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('User').doc(uid).set(userData);
  }
}
