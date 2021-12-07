import 'package:flutter/material.dart';
import 'package:fluttercocktail/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cocktail App",
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: "Pacifico",
      ),
      home: HomePage(),
    );
  }
}
