import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/ogrenci.dart';
import 'package:flutter_app/utils/database_helper.dart';

class SqfliteIslemleri extends StatefulWidget {
  @override
  _SqfliteIslemleriState createState() => _SqfliteIslemleriState();
}

class _SqfliteIslemleriState extends State<SqfliteIslemleri> {
  DatabaseHelper _databaseHelper;
  List<Ogrenci> tumOgrenciler;
  var _formKey = GlobalKey<FormState>();
  bool aktiflik = false;
  var _controller = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int tiklanilanIndex;
  int tiklanilanId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumOgrenciler = List<Ogrenci>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.tumOgrenciler().then((tumOgrencileriTutanMapListesi) {
      for (Map okunanOgrenciMapi in tumOgrencileriTutanMapListesi) {
        tumOgrenciler.add(Ogrenci.fromMap(okunanOgrenciMapi));
      }
      print("dbden gelen öğrenci sayısı: " + tumOgrenciler.length.toString());
    }).catchError((hata) => print("hata" + hata));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("SqfLite Kullanımı"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: false,
                        controller: _controller,
                        validator: (kontrolEdilecekIsimDegeri) {
                          if (kontrolEdilecekIsimDegeri.length < 3) {
                            return "en az 3 karakter giriniz";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Ogrenci ismini giriniz",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SwitchListTile(
                      title: Text("Aktif"),
                      value: aktiflik,
                      onChanged: (aktifMi) {
                        setState(() {
                          aktiflik = aktifMi;
                        });
                      },
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Kaydet"),
                    color: Colors.green,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _ogrenciEkle(Ogrenci(
                            _controller.text, aktiflik == true ? 1 : 0));
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text("Güncelle"),
                    color: Colors.blue,
                    onPressed: tiklanilanId == null
                        ? null
                        : () {
                            if (_formKey.currentState.validate()) {
                              _ogrenciGuncelle(Ogrenci.withID(tiklanilanId,
                                  _controller.text, aktiflik == true ? 1 : 0));
                            }
                          },
                  ),
                  RaisedButton(
                    child: Text("Tüm Tabloyu Sil"),
                    color: Colors.red,
                    onPressed: () {
                      _tumTabloyuTemizle();
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: tumOgrenciler.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: tumOgrenciler[index].aktif == 1
                            ? Colors.yellow
                            : Colors.grey,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              _controller.text = tumOgrenciler[index].isim;
                              aktiflik = tumOgrenciler[index].aktif == 1
                                  ? true
                                  : false;
                              tiklanilanIndex = index;
                              tiklanilanId = tumOgrenciler[index].id;
                            });
                          },
                          title: Text(tumOgrenciler[index].isim),
                          subtitle: Text(tumOgrenciler[index].id.toString()),
                          trailing: GestureDetector(
                              onTap: () {
                                _ogrenciSil(tumOgrenciler[index].id, index);
                              },
                              child: Icon(Icons.delete)),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }

  void _ogrenciEkle(Ogrenci ogrenci) async {
    var eklenenID = await _databaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = eklenenID;
    if (eklenenID > 0) {
      setState(() {
        tumOgrenciler.insert(0, ogrenci);
      });
    }
  }

  void _tumTabloyuTemizle() async {
    var silinenElemanSayisi = await _databaseHelper.tumOgrenciTablosunuSil();
    if (silinenElemanSayisi > 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(silinenElemanSayisi.toString() + " Kayıt Silindi"),
      ));
      setState(() {
        tumOgrenciler.clear();
      });
    }
    tiklanilanId=null;
  }

  void _ogrenciSil(int id, int index) async {
    var sonuc = await _databaseHelper.ogrenciSil(id);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Kayıt Silindi"),
      ));
      setState(() {
        tumOgrenciler.removeAt(index);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Silerken Hata Oluştu"),
      ));
    }
    tiklanilanId=null;
  }

  Future<void> _ogrenciGuncelle(Ogrenci ogrenci) async {
    var sonuc = await _databaseHelper.ogrenciGuncelle(ogrenci);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Kayıt Güncellendi"),
      ));
      setState(() {
        tumOgrenciler[tiklanilanIndex] = ogrenci;
      });
    }
  }
}
