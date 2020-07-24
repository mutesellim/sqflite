import 'package:flutter/material.dart';
import 'package:flutter_app/model/ogrenci.dart';
import 'package:flutter_app/sqflite_islemleri.dart';
import 'package:flutter_app/utils/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SqfliteIslemleri(),
    );
  }
}
