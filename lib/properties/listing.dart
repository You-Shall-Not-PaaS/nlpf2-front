import 'package:flutter/material.dart';
import 'package:nlpf2/properties/properties.dart';
import 'package:nlpf2/properties/map.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({Key? key, required this.property}) : super(key: key);

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(color: Colors.blue),
            ),
          ),
          Expanded(
            flex: 3,
            child: _PropertyDetails(
              property: property,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class _PropertyDetails extends StatelessWidget {
  const _PropertyDetails({Key? key, required this.property}) : super(key: key);

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            property.type_local,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            property.commune,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '${property.valeur_fonciere} €',
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '${property.surface_reelle_bati} m²',
            style: const TextStyle(fontSize: 10.0),
          )
        ],
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class Listing extends StatefulWidget {
  const Listing({Key? key, required this.properties}) : super(key: key);
  final List<Property> properties;
  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8.0),
        itemExtent: 106.0,
        children: [
          for (var property in widget.properties)
            CustomListItem(property: property),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PropertyMap()));
              },
              child: const Text('Afficher la carte'))
        ]);
  }
}

/*
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
*/