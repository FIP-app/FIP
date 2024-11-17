import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/interfaces/Documentable.dart';

class User implements Documentable {
  late String _name, _email, _birth, _uid;

  String get name => _name;

  User(String name, String email, String birth, String id) {
    _name = name;
    _email = email;
    _birth = birth;
    _uid = id;
  }

  User.fromFireStore(String id, DocumentSnapshot<Map<String, dynamic>> doc) {
    _name = doc["name"];
    _email = doc["email"];
    _birth = doc["birth"];
    _uid = id;
  }

  @override
  Map<String, dynamic> convertToDoc() {
    Map<String, dynamic> doc = Map();
    doc.putIfAbsent("name", () => _name);
    doc.putIfAbsent("email", () => _email);
    doc.putIfAbsent("birth", () => _birth);
    doc.putIfAbsent("uid", () => _uid);
    return doc;
  }
}
