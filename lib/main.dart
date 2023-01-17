import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/favorite_page.dart';
import 'pages/search_page.dart';
import 'restaurant_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/favorite': (context) => FavoritePage(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}
