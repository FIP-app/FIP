import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyecto/interfaces/Documentable.dart';

class DocumentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void insertRecord(
      {required String collection,
      required Documentable doc,
      required Function onError,
      required Function onSuccess}) {
    var document = doc.convertToDoc();
    String uid = document["uid"];
    //document.remove("uid");

    _firestore
        .collection(collection)
        .doc(uid)
        .set(document)
        .onError((error, stackTrace) => onError(error))
        .then((value) => onSuccess());
  }

  void getRecord(
      {required String collection,
      required String doc,
      required Function onSuccess,
      required Function onError}) {
    _firestore
        .collection(collection)
        .doc(doc)
        .get()
        .then((value) => onSuccess(value), onError: onError);
  }
}
