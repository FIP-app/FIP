import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TestProvider extends ChangeNotifier {
  HashMap<String, int> _players = HashMap();

  late CollectionReference<Map<String, dynamic> > _collection;

  TestProvider() {
    _collection = FirebaseFirestore.instance.collection("users");
  }  

  void increaseScore(String name) {

    if (_players[name] == null) _players[name] = 0;
    _players[name] = (_players[name]! + 1);
  }
}