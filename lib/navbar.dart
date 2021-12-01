import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text('BenchIMMO'),
          actions: <Widget>[
            // TextButton(
            //   style: TextButton.styleFrom(
            //     primary: Colors.white,
            //     textStyle: const TextStyle(fontSize: 20),
            //   ),
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, '/');
            //   },
            //   child: const Text('Home'),
            // ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/listing');
              },
              child: const Text('Propriétés'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/Estimation');
              },
              child: const Text('Estimation'),
            )
          ],
        ),
        body: Center(child: child));
  }
}
