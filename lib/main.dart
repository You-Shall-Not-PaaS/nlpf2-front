import 'package:flutter/material.dart';
import 'package:nlpf2/home.dart';
import 'package:nlpf2/navbar.dart';
import 'package:nlpf2/properties/estimate.dart';
import 'package:nlpf2/properties/properties.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "../.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BenchIMMO',
        initialRoute: '/listing',
        routes: {
          // '/': (context) => const Navbar(child: Home()),
          '/listing': (context) => const Navbar(child: Properties()),
          '/Estimation': (context) => const Navbar(child: Estimation())
        },
        theme: ThemeData(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ));
  }
}
