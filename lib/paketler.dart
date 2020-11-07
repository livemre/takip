import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Paketler extends StatelessWidget {
  Color renk;
  String baslik;
  String altBaslik;
  String krediDegeri;
  double bosluk = 6.0;
  Icon icon;

  Paketler(
      {this.renk, this.baslik, this.altBaslik, this.krediDegeri, this.bosluk, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: renk,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                baslik,
                style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),

              ),
              SizedBox(width: 5,),
              Text(
                altBaslik,
                style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,

              Card(
                  color: Colors.black45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      krediDegeri,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
