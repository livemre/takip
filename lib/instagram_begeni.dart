import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:likefan/begeni_paket_listesi.dart';
import 'package:likefan/paketler.dart';

import 'package:http/http.dart' as http;

class InstagramBegeni extends StatefulWidget {
  @override
  _InstagramBegeniState createState() => _InstagramBegeniState();
}

class _InstagramBegeniState extends State<InstagramBegeni> {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _gonderiGetir(),
      builder: (BuildContext context,
          AsyncSnapshot<List<BegeniPaketListesi>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        alertDialog(context, snapshot.data[index].baslik);
                        debugPrint("Tab");
                      },
                      child: Paketler(
                        baslik: snapshot.data[index].baslik.toString(),
                        altBaslik: snapshot.data[index].alt_baslik,
                        krediDegeri: snapshot.data[index].urun_degeri,
                        renk: Colors.red,
                        bosluk: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: snapshot.data.length,
          );
        } else {
          debugPrint(snapshot.toString());
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  void alertDialog(BuildContext context, int id) {
    var alert = AlertDialog(
      title: Text(id.toString()),
      content: Column(
        children: [
          Text("Kilidi aç ve maçları gör"),
          RaisedButton(
            child: Text("5 kredi"),
            onPressed: () {},
          ),
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
