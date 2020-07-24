import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/ogrenci.dart';
import 'package:flutter_app/sqflite_islemleri.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String _ogrenciTablo = "ogrenci";
  String _columnID = "id";
  String _columnIsim = "isim";
  String _columnAktif = "aktif";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  _initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = join(klasor.path, "ogrenci.db");
    print("DB Path:" + dbPath);
    var ogrenciDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
    return ogrenciDB;
  }

  Future<FutureOr<void>> _createDB(Database db, int version) async {
    print("create çalıştı");
    await db.execute(
        "CREATE TABLE $_ogrenciTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnIsim TEXT, $_columnAktif INTEGER )");
  }

  Future<int> ogrenciEkle(Ogrenci ogrenci) async {
    print("ekle çalıştı");
    var db = await _getDatabase();
    var sonuc = await db.insert(_ogrenciTablo, ogrenci.toMap(),
        nullColumnHack: "$_columnID");
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumOgrenciler() async {
    var db = await _getDatabase();
    var sonuc = await db.query(_ogrenciTablo, orderBy: "$_columnID DESC");
    return sonuc;
  }

  Future<int> ogrenciGuncelle(Ogrenci ogrenci) async {
    var db = await _getDatabase();
    var sonuc = await db.update(_ogrenciTablo, ogrenci.toMap(),
        where: "$_columnID = ?", whereArgs: [ogrenci.id]);
    return sonuc;
  }

  Future ogrenciSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete(_ogrenciTablo, where: "$_columnID=?", whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumOgrenciTablosunuSil() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_ogrenciTablo);
    return sonuc;
  }


}
