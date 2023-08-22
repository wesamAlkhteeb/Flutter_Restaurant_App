

import 'package:cloud_firestore/cloud_firestore.dart';

class LoadToken{
  late String id;
  LoadToken({required this.id});

  Future<String> getToken() async{
    final account = await FirebaseFirestore.instance.collection("User").where("id" ,isEqualTo: id).get();
    return account.docs[0].data()["tokenNotification"];
  }
}