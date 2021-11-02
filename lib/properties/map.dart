import 'package:flutter/material.dart';

class PropertyMap extends StatefulWidget {
  const PropertyMap({Key? key}) : super(key: key);
  @override
  State<PropertyMap> createState() => _PropertyMapState();
}

class _PropertyMapState extends State<PropertyMap> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Map"),
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Hide The Map'))
    ]);
  }
}
