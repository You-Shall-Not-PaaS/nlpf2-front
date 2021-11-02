import 'package:flutter/material.dart';
import 'package:nlpf2/properties/properties.dart';
import 'package:nlpf2/properties/map.dart';

class Listing extends StatefulWidget {
  const Listing({Key? key, required this.properties}) : super(key: key);
  final List<Property> properties;
  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Listing'),
      for (var property in widget.properties)
        Text(property.city + ' ' + property.price.toString()),
      ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PropertyMap()));
          },
          child: const Text('Display The Map'))
    ]);
  }
}
