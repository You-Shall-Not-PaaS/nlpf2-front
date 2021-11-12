import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PropertyMap extends StatefulWidget {
  const PropertyMap({Key? key, required this.properties}) : super(key: key);
  final List<Property> properties;
  @override
  State<PropertyMap> createState() => _PropertyMapState();
}

class _PropertyMapState extends State<PropertyMap> {
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _markers = properties
        .map((property) => Marker(
            width: 80.0,
            height: 80.0,
            point:  LatLng(48.833297, 2.300999),
            builder: (ctx) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopUp(property: property)));
                },
                child: const Icon(Icons.pin_drop_sharp, color: Colors.red))))
        .toList();

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

class PopUp extends StatelessWidget {
  const PopUp({Key? key, required this.property}) : super(key: key);
  final Property property;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Property"),
        ),
        body: Center(
            child: Column(children: [
          Text(
              "price: " + property.price.toString() + " city: " + property.city,
              style: TextStyle(fontSize: 20)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("go back"),
          ),
        ])));
  }
}