import 'package:flutter/material.dart';
import 'package:flutter_login_demo/firebase/authentication.dart';
import 'package:flutter_login_demo/firebase/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth())); // ไปหน้า Root_page
  }
}
