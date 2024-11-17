import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  bool getIsLogged() {
    try {
      var user = _auth.currentUser;
      return user != null;
    } catch(e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<String> register(String email, String password) async  {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

}