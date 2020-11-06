import 'package:cloud_firestore/cloud_firestore.dart';

class SiparisService {
  getLastReview(String userID){
    return Firestore.instance
        .collection("Siparisler")
        .where('siparis_veren',isEqualTo: userID)
        .getDocuments();
  }



}