import 'package:flutter/material.dart';
import 'package:nlpf2/home.dart';
import 'package:nlpf2/navbar.dart';
import 'package:nlpf2/properties/properties.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NLPF',
        initialRoute: '/',
        routes: {
          '/': (context) => const Navbar(child: Home()),
          '/listing': (context) => const Navbar(child: Properties())
        },
        theme: ThemeData(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ));
  }
}
