import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dashboard.dart';


class GoogleIleGiris extends StatefulWidget {
  @override
  _GoogleIleGirisState createState() => _GoogleIleGirisState();
}

class _GoogleIleGirisState extends State<GoogleIleGiris> {
  User _user = FirebaseAuth.instance.currentUser;
  int _kredi;
  GoogleSignIn _signIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        if (user != null) {
          _user = user;
          krediVer();
        }
      });
    });
    super.initState();
  }

  Future<void> logout() async {
    await _signIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> login() async {
    try {
      GoogleSignIn signIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount account = await signIn.signIn();
      GoogleSignInAuthentication auth = await account.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      debugPrint(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/bg.jpg"),fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset("assets/1511.png",height: 125,width: 125,),
          Text("Pretty Like",style: TextStyle(color: Colors.red,fontSize: 36,fontWeight: FontWeight.bold),),
          Container(
            child: _user == null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.g_translate,color: Colors.white,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Google ile giriş yap.",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    login();
                  },
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> krediVer() async {
    DocumentReference veriyolu =
    Firestore.instance.collection("Uyeler").document(_user.uid);

    veriyolu.get().then((alinanveri) {
      if (alinanveri.exists == true) {
        setState(() {
          _kredi = alinanveri.data()["kredi"];


          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return Dashboard(_user, _kredi);
              }));
        });
      } else {
        debugPrint("kullanıcı var. Veritabanı yok");
        dashBoardGit();
      }
    });
  }

  Future<void> dashBoardGit() async {
    debugPrint("dashboard git ${_kredi}");

    DocumentReference veriyolu =
    Firestore.instance.collection("Uyeler").document(_user.uid);

    Map<String, dynamic> urunler = {
      "adi": _user.uid,
      "kredi": 0,
    };

    await veriyolu.setData(urunler).whenComplete(() {
      debugPrint("İşlem başarılı");

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return Dashboard(_user, 0);
          }));
    });
  }
}
