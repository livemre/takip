import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:likefan/siparis_listesi.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:likefan/siparisler_service.dart';

class Siparislerim extends StatefulWidget {
  User _kullanici;
  var siparislistesi;

  Siparislerim(User kullanici) {
    this._kullanici = kullanici;
  }

  @override
  _SiparislerimState createState() => _SiparislerimState();
}

class _SiparislerimState extends State<Siparislerim> {
  SlidableController slidableController;
  final _formKey = GlobalKey<FormState>();
  String duzenlenenVeri;
  var cekilenveri;

  @override
  void initState() {
    super.initState();
    SiparisService()
        .getLastReview(widget._kullanici.uid)
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          cekilenveri = docs.docs;
        });
      } else {
        cekilenveri = "Boş";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siparislerim"),
      ),
      body: ListView.builder(
        itemCount: cekilenveri.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){debugPrint(cekilenveri[index]["siparisadi"].toString());},
            child: Text(cekilenveri[index]["siparisadi"]),
          );
        },
      ),
    );
  }


}
