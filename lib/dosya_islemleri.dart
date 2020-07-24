import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class DosyaIslemleri extends StatefulWidget {
  @override
  _DosyaIslemleriState createState() => _DosyaIslemleriState();
}

class _DosyaIslemleriState extends State<DosyaIslemleri> {
  var myTextController = TextEditingController();

  Future<String> get getklasorYolu async {
    Directory klasor = await getApplicationDocumentsDirectory();
    return klasor.path;
  }

  Future<File> get dosyaOlustur async {
    var dosyaYolu = await getklasorYolu;
    return File(dosyaYolu + "/myDosya.txt");
  }

  Future<String> dosyaOku() async {
    try {
      var myDosya = await dosyaOlustur;
      String dosyaIcerigi = await myDosya.readAsString();
      return dosyaIcerigi;
    } catch (exception) {
      return "Hata Çıktı $exception";
    }
  }

  Future<File> dosyayaYaz(String yazilacakString) async {
    var myDosya = await dosyaOlustur;
    return myDosya.writeAsString(yazilacakString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dosya İşlemleri"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myTextController,
                maxLines: 4,
                decoration: InputDecoration(hintText: "Buraya yazılacak deger"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: _dosyaYaz,
                  color: Colors.green,
                  child: Text("Dosyaya Yaz"),
                ),
                RaisedButton(
                  onPressed: _dosyaOku,
                  color: Colors.blue,
                  child: Text("Dosyadan Oku"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _dosyaYaz() {
    dosyayaYaz(myTextController.text.toString());
  }

  void _dosyaOku() {
    dosyaOku().then((icerik) => debugPrint(icerik));
  }
}
