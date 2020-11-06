import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Paketler extends StatelessWidget {
  Color renk;
  String baslik;
  String altBaslik;
  String krediDegeri;
  double bosluk = 12.0;

  Paketler(
      {this.renk, this.baslik, this.altBaslik, this.krediDegeri, this.bosluk});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: renk,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(bosluk),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            baslik,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            altBaslik,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Card(
              color: Colors.black45,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  krediDegeri,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )),
        ],
      ),
    );
  }
}
