import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:likefan/main.dart';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:likefan/paketler.dart';
import 'package:likefan/siparislerim_sayfasi.dart';

import 'begeni_paket_listesi.dart';
import 'instagram_begeni.dart';

class Dashboard extends StatefulWidget {
  User _kullanici;
  int _kredi;

  Dashboard(User kullanici, int kredi) {
    this._kullanici = kullanici;
    this._kredi = kredi;
  }

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  String gonderilenDeger;
  var besbinkrediParasi;
  String besbinkrediParasi2misli;
  GoogleSignIn _signIn = GoogleSignIn(scopes: ["email"]);

  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    InAppPurchaseConnection.enablePendingPurchases();

    final Stream<List<PurchaseDetails>> purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;

    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });

    setState(() {
      _binkrediDegerleriAl();
    });

    veriOku();

    super.initState();
  }

  Future<List<BegeniPaketListesi>> _gonderiGetir() async {
    var response = await http.get("https://arena.tips/kuponlistesi.json");
    if (response.statusCode == 200) {
      //return Gonderi.fromJsonMap(json.decode(response.body));
      return (json.decode(response.body) as List)
          .map((tekGonderiMap) => BegeniPaketListesi.fromJsonMap(tekGonderiMap))
          .toList();
    } else {
      throw Exception("Bağlanamadı ${response.statusCode}");
    }
  }

  Future<List<BegeniPaketListesi>> _gonderiGetir2() async {
    var response = await http.get("https://arena.tips/kuponlistesi2.json");
    if (response.statusCode == 200) {
      //return Gonderi.fromJsonMap(json.decode(response.body));
      return (json.decode(response.body) as List)
          .map((tekGonderiMap) => BegeniPaketListesi.fromJsonMap(tekGonderiMap))
          .toList();
    } else {
      throw Exception("Bağlanamadı ${response.statusCode}");
    }
  }

  Future<List<BegeniPaketListesi>> _gonderiGetir3() async {
    var response = await http.get("https://arena.tips/kuponlistesi3.json");
    if (response.statusCode == 200) {
      //return Gonderi.fromJsonMap(json.decode(response.body));
      return (json.decode(response.body) as List)
          .map((tekGonderiMap) => BegeniPaketListesi.fromJsonMap(tekGonderiMap))
          .toList();
    } else {
      throw Exception("Bağlanamadı ${response.statusCode}");
    }
  }

  @override
  Widget createRegionsListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return values.isNotEmpty
            ? Container(
          color: Colors.orange,
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  alertDialog(
                      context,
                      values[index].urun_adi,
                      values[index].baslik,
                      values[index].girilecekVeri,
                      values[index].odenecek_kredi);
                  debugPrint("Tab");
                },
                child: Paketler(
                  baslik: values[index].baslik.toString(),
                  altBaslik: values[index].alt_baslik,
                  krediDegeri: values[index].urun_degeri,
                  renk: Colors.deepOrange,
                  bosluk: 12,
                ),
              ),
            ],
          ),
        )
            : CircularProgressIndicator();
      },
    );
  }

  Widget createCountriesListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: values == null ? 0 : values.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.blue.shade400,
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  alertDialog(
                      context,
                      values[index].urun_adi,
                      values[index].baslik,
                      values[index].girilecekVeri,
                      values[index].odenecek_kredi);
                  debugPrint("Tab");
                },
                child: Paketler(
                  baslik: values[index].baslik.toString(),
                  altBaslik: values[index].alt_baslik,
                  krediDegeri: values[index].urun_degeri,
                  renk: Colors.lightBlueAccent,
                  bosluk: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget createUcuncuListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: values == null ? 0 : values.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.purpleAccent,
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  alertDialog(
                      context,
                      values[index].urun_adi,
                      values[index].baslik,
                      values[index].girilecekVeri,
                      values[index].odenecek_kredi);
                  debugPrint("Tab");
                },
                child: Paketler(
                  baslik: values[index].baslik.toString(),
                  altBaslik: values[index].alt_baslik,
                  krediDegeri: values[index].urun_degeri,
                  renk: Colors.purple,
                  bosluk: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1000,
            //height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Container(
                  alignment: Alignment.bottomLeft,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                            radius: 30,
                            child: Image.network(widget._kullanici.photoURL)),
                        Column(
                          children: [
                            RaisedButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return Siparislerim(widget._kullanici);
                              }

                              ));
                            },),
                            Text(
                              "Hoşgeldiniz,",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              widget._kullanici.displayName,
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "Bakiye: " + widget._kredi.toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            logout();
                          },
                        ),
                      ],
                    ),
                  )),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Kredi Satın Al",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  )),
              Container(
                height: 250,
                child: Container(
                  color: Colors.green,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.white60,
                            onPressed: _besbinkredi,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "100",
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "KREDİ",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: SizedBox(
                                        height: 1,
                                        width: 75,
                                        child: Container(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    besbinkrediParasi2misli == null
                                        ? CircularProgressIndicator()
                                        : Text(
                                      besbinkrediParasi2misli + " TL",
                                      style: TextStyle(
                                          decoration:
                                          TextDecoration.lineThrough,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                    besbinkrediParasi == null
                                        ? CircularProgressIndicator()
                                        : Text(
                                      besbinkrediParasi.toString() +
                                          " TL",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Satın Al",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: Colors.blue,
                child: Text(
                  "Beğeni Paketleri",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _gonderiGetir2(),
                    initialData: [],
                    builder: (context, snapshot) {
                      return createCountriesListView(context, snapshot);
                    }),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: Colors.deepOrange,
                child: Text(
                  "Takipçi Paketleri",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _gonderiGetir(),
                    initialData: [],
                    builder: (context, snapshot) {
                      return createRegionsListView(context, snapshot);
                    }),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: Colors.purple,
                child: Text(
                  "Gönderi Beğenme Paketleri",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _gonderiGetir3(),
                    initialData: [],
                    builder: (context, snapshot) {
                      return createUcuncuListView(context, snapshot);
                    }),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void alertDialog(BuildContext context, String urun_adi, int baslik,
      String girilecekVeri, int odenecek_kredi) {
    var alert = AlertDialog(
      title: Container(
          alignment: Alignment.center,
          child: Text(
            urun_adi,
            style: TextStyle(color: Colors.blue),
          )),
      content: SizedBox(
        height: 220,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: girilecekVeri),
                    validator: (value) {
                      debugPrint(value);
                      setState(() {
                        gonderilenDeger = value;
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
            widget._kredi < odenecek_kredi
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  Text(
                    "Krediniz Yetersiz",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            )
                : RaisedButton(
              color: Colors.blue,
              child: widget._kredi < odenecek_kredi
                  ? Text("Krediniz Yetersiz")
                  : Text("Siparişi Yolla"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  siparisYolla(baslik, gonderilenDeger, odenecek_kredi, urun_adi);
                  final snackBar = SnackBar(
                    content: Text(
                        'Siparişiniz alındı çok yakında işleme alınacaktır.'),
                    backgroundColor: Colors.green,
                  );

                  Scaffold.of(context).showSnackBar(snackBar);
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
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future begenileriCek() async {
    return await InstagramBegeni();
  }

  Future<void> _binkredi() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    print("bool _loadingProductsForSale");
    if (!available) {
      Fluttertoast.showToast(
        msg:
        "Maalesef satın alma aktif değil. Daha sonra tekrar deneyebilirsiniz.",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
      );
      print("false _loadingProductsForSale");
    } else {
      print("true _loadingProductsForSale");
      // Set literals require Dart 2.2. Alternatively, use `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
      const Set<String> _kIds = {'point_1000'};
      final ProductDetailsResponse response =
      await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        Fluttertoast.showToast(
          msg:
          "Maalesef satın alma kimliği bulunamadı. Daha sonra tekrar deneyebilirsiniz.",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
        );
        print("true esponse.notFoundIDs.isNotEmpty");
      }
      List<ProductDetails> products = response.productDetails;
      for (ProductDetails p in products.take(1)) {
        print(p.title);
        print(p.price);
        final PurchaseParam purchaseParam = PurchaseParam(productDetails: p);
        /* if (_isConsumable(productDetails)) {
          InAppPurchaseConnection.instance.buyConsumable(purchaseParam: purchaseParam);
        } else {
          InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
        } */
        try {
          bool sonuc = await InAppPurchaseConnection.instance
              .buyConsumable(purchaseParam: purchaseParam);

          print("buyConsumable: $sonuc");
        } on PlatformException catch (e) {
          String error =
              "PlatformException code: ${e.code}, message: ${e.message}, details: ${e.details}";
          print(error);

          Fluttertoast.showToast(
              msg: error,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3);
        } catch (e) {
          String error = "catch error: ${e.toString()}";
          print(error);

          Fluttertoast.showToast(
              msg: error,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3);
        }
      }
    }
  }

  Future<void> _binkrediDegerleriAl() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    const Set<String> _kIds = {'5000_point'};
    final ProductDetailsResponse response =
    await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
    List<ProductDetails> products = response.productDetails;
    for (ProductDetails p in products.take(1)) {
      print(p.title);
      print(p.price);

      besbinkrediParasi = p.skuDetail.priceAmountMicros / 1000000;
      var intdeger = p.skuDetail.priceAmountMicros / 1000000 * 2;
      besbinkrediParasi2misli = intdeger.toString();

      setState(() {});
    }
  }

  Future<void> _besbinkredi() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    print("bool _loadingProductsForSale");
    if (!available) {
      Fluttertoast.showToast(
        msg:
        "Maalesef satın alma aktif değil. Daha sonra tekrar deneyebilirsiniz.",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
      );
      print("false _loadingProductsForSale");
    } else {
      print("true _loadingProductsForSale");
      // Set literals require Dart 2.2. Alternatively, use `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
      const Set<String> _kIds = {'5000_point'};
      final ProductDetailsResponse response =
      await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        Fluttertoast.showToast(
          msg:
          "Maalesef satın alma kimliği bulunamadı. Daha sonra tekrar deneyebilirsiniz.",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
        );
        print("true esponse.notFoundIDs.isNotEmpty");
      }
      List<ProductDetails> products = response.productDetails;
      for (ProductDetails p in products.take(1)) {
        print(p.title);
        print(p.price);
        final PurchaseParam purchaseParam = PurchaseParam(productDetails: p);
        /* if (_isConsumable(productDetails)) {
          InAppPurchaseConnection.instance.buyConsumable(purchaseParam: purchaseParam);
        } else {
          InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
        } */
        try {
          bool sonuc = await InAppPurchaseConnection.instance
              .buyConsumable(purchaseParam: purchaseParam);

          print("buyConsumable: $sonuc");
        } on PlatformException catch (e) {
          String error =
              "PlatformException code: ${e.code}, message: ${e.message}, details: ${e.details}";
          print(error);

          Fluttertoast.showToast(
              msg: error,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3);
        } catch (e) {
          String error = "catch error: ${e.toString()}";
          print(error);

          Fluttertoast.showToast(
              msg: error,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3);
        }
      }
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> pList) {
    for (PurchaseDetails p in pList) {
      switch (p.status) {
        case PurchaseStatus.purchased:
          debugPrint("satın alındı" + p.productID);
          setState(() {
            widget._kredi = widget._kredi + 5000;
            veriGuncelle();
          });

          if (p.productID == "5000_point") {
            Fluttertoast.showToast(
              msg: "Teşekkür ederiz. 5000 Puan satın aldınız.",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
            );
          }

          if (p.productID == "point_1000") {
            Fluttertoast.showToast(
              msg: "Teşekkür ederiz. 1000 Puan satın aldınız.",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
            );
          }

          break;
        case PurchaseStatus.pending:
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Ödemeniz bekleme durumunda"),
                content: Text(
                  "İşlem başarıyla tamamlandığında krediniz profilinize tanımlanacaktır.",
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Tamam")),
                ],
              );
            },
          );
          break;
        case PurchaseStatus.error:
          if (p.error.message == "BillingResponse.itemAlreadyOwned") {
            Fluttertoast.showToast(
              msg:
              "Teşekkür ederiz. Krediler profinize tanımlandı istediğiniz zaman kullanabilirsiniz.",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
            );
          }

          break;
        default:
          break;
      }
    }
  }

// Fonksiyon, satın alınma işleminde veritabanına bağlanacak ve kalan krediyi güncelleyecek.
// Siparişi veritabanına kaydedecek.

  Future veriOku() async {
    DocumentReference veriyolu = Firestore.instance
        .collection("Uyeler")
        .document(widget._kullanici.uid);

    veriyolu.get().then((alinanveri) {
      if (alinanveri.data()["kredi"] != null) {
        setState(() {
          widget._kredi = alinanveri.data()["kredi"];
        });
      } else {
        widget._kredi = 0;
      }
    });
  }

  Future<void> veriGuncelle() async {
    DocumentReference veriyolu = Firestore.instance
        .collection("Uyeler")
        .document(widget._kullanici.uid);

    Map<String, dynamic> urunler = {
      "kredi": widget._kredi,
    };

    await veriyolu.update(urunler).whenComplete(() {
      debugPrint("Kredi güncelleme işlemi başarılı");
    });
  }

  Future<void> siparisYolla(
      int deger, String gonderilen, int odenecek_kredi, String urun_adi) async {
    DocumentReference veriyolu = Firestore.instance
        .collection("Siparisler").doc();

    DocumentSnapshot doc = await veriyolu.get();
    //List siparislerim = doc.data()["siparisler"];



    Map<String, dynamic> siparisler = {
      "siparis_veren" : widget._kullanici.uid,
      "id" : 111,
      "siparis_tarihi" : DateTime.now().day.toString() + "/" + DateTime.now().month.toString() + "/"+  DateTime.now().year.toString() + " " + DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString(),
      "siparis_aciklamasi" :  urun_adi,
      "siparisadi": gonderilen,
      "kredisi": odenecek_kredi,
      "tamamlandi": false,
      "timeStamp" : DateTime.now(),
    };

    Map<String, dynamic> urunler = {
      "adi": widget._kullanici.uid,
      "newuser": true,
      "ziparisler" : siparisler,
    };
    setState(() {
      widget._kredi = widget._kredi - odenecek_kredi;
    });

    Map<String, dynamic> meyve = {
      "adi" : "elma"

    };


    veriGuncelle();

    veriOku();


   await veriyolu.setData(siparisler)

   .whenComplete(() {
     debugPrint("Kredi güncelleme işlemi başarılı");
   });
  }

  Future<void> logout() async {
    await _signIn.signOut();
    await FirebaseAuth.instance.signOut();
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return MyApp();
        }));
  }





}
