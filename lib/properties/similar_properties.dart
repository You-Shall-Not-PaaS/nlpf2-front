import 'package:flutter/material.dart';
import 'package:nlpf2/properties/listing.dart';
import 'package:nlpf2/properties/map.dart';
import 'package:nlpf2/service/service.dart';

/// This is the stateless widget that the main application instantiates.
class Similar extends StatefulWidget {
  const Similar({Key? key, required this.properties}) : super(key: key);
  final List<Property> properties;
  @override
  State<Similar> createState() => _SimilarState();
}

class _SimilarState extends State<Similar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            itemExtent: 106.0,
            children: [
          for (var property in widget.properties)
            Container(
                decoration: const BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.blueGrey))),
                child: CustomListItem(property: property))
        ]));
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({Key? key, required this.property}) : super(key: key);

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 2, child: selectTypeIcon(property.type_local)),
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
    return Expanded(
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
