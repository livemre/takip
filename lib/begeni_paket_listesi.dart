class BegeniPaketListesi{
  String urun_adi;
  String girilecekVeri;
  int baslik;
  String alt_baslik;
  String urun_degeri;
  int odenecek_kredi;
  bool canSell;


  BegeniPaketListesi.fromJsonMap(Map<String, dynamic> map):
        urun_adi = map["urun_adi"],
        girilecekVeri = map["girilecekVeri"],
        baslik = map["baslik"],
        alt_baslik = map["alt_baslik"],
        urun_degeri = map["urun_degeri"],
        odenecek_kredi = map["odenecek_kredi"],
        canSell = map["canSell"];
}