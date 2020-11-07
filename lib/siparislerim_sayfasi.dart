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
  bool verilercekildi = false;
  String gonderilendeger;
  String currentData;

  @override
  void initState() {
    super.initState();

    setState(() {
      verileriCek();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siparislerim"),
      ),
      body: verilercekildi == false ? Center(child: Text("Hiç siparişiniz yok")) : ListView.builder
        (
          itemCount: cekilenveri.length,
          itemBuilder: (BuildContext context, int index) {
            return  GestureDetector(
              onTap: (){

                setState(() {
                  currentData = cekilenveri[index]["siparisadi"];
                });

                alertDialog(cekilenveri[index].id,gonderilendeger,cekilenveri[index]["tamamlandi"],cekilenveri[index]["siparis_aciklamasi"]);

              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.edit),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cekilenveri[index]["siparis_tarihi"].toString()),
                                Text(cekilenveri[index]["siparisadi"].toString(),style: TextStyle(color: Colors.white,fontSize: 16),),
                              ],
                            ),
                          ],
                        ),
                        cekilenveri[index]["tamamlandi"] == false ? Icon(Icons.timelapse) : Icon(Icons.check)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      )
    );
  }


  Future <void> verileriCek(){
    FirebaseFirestore.instance
        .collection('Siparisler')
        .where('siparis_veren',isEqualTo: widget._kullanici.uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
      cekilenveri = querySnapshot.docs,
      //debugPrint("idsi" +querySnapshot.docs[0].id.toString()),
          querySnapshot.docs.forEach((element) {
            //debugPrint("Veri :" + );
            setState(() {
              verilercekildi = true;
            });
          })
    });
  }


  void alertDialog(String id, String girilecekveri, bool tamam, String aciklama) {
    var alert = AlertDialog(
       title: Container(
          alignment: Alignment.center,
          child: Text(
            aciklama,
            style: TextStyle(color: Colors.blue),
          )),
      content: tamam == false ? SizedBox(
        height: 220,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: currentData),
                    initialValue: currentData,
                    validator: (value) {
                      debugPrint(value);
                      setState(() {
                        gonderilendeger = value;
                      });
                      if (value.isEmpty) {
                        return "Lütfen bir şeyler yazın";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
                 RaisedButton(
              color: Colors.blue,
              child: Text("Düzenleme Yolla"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  updateUser(id,gonderilendeger);
                  Navigator.pop(context);
                }
              },
            ),
            RaisedButton(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("İptal", style: TextStyle(color: Colors.white),),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ) : Text("Tamamlanmış siparişler düzenlenemez"),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }


  CollectionReference users = FirebaseFirestore.instance.collection('Siparisler');

  Future<void> updateUser(String id, String guncellenecekveri) {
    return users
        .doc(id)
        .update({'siparisadi': guncellenecekveri})
        .then((value) => verileriCek())
        .catchError((error) => print("Failed to update user: $error"));


  }


}
