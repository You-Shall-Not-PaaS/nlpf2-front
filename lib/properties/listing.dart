import 'package:flutter/material.dart';
import 'package:nlpf2/properties/map.dart';
import 'package:nlpf2/properties/properties.dart';
import 'package:nlpf2/service/service.dart';
import 'package:tuple/tuple.dart';

/// This is the stateless widget that the main application instantiates.
class Listing extends StatefulWidget {
  const Listing({Key? key, required this.properties}) : super(key: key);
  final Tuple2<List<Property>, List<Future<Property?>>> properties;
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
        Container(
            decoration: const BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.blueGrey))),
            child: InkWell(
                onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return DescriptionWidget(property: property);
                      },
                    ),
                // onTap: () => showDialog(context: context, builder: return MyAlertDialog(property: property)), // handle your onTap here
                child: CustomListItem(property: property))),
      //   child: CustomListItem(property: property))
    ]);
  }
}

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

selectTypeIcon(propertyType) {
  switch (propertyType) {
    case "Maison":
      return Image.asset('maison.png');
    case "Appartement":
      return Image.asset('appartement.png');
    case "Dépendance":
      return Image.asset('dependance.png');
    default:
      return Image.asset('autres.png');
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({Key? key, required this.property}) : super(key: key);

  final Property property;
  //final Future<Label> label = FutureBuilder(builder: builder)   getLabels(this.property.id.toString());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: FittedBox(
              fit: BoxFit.none, // otherwise the logo will be tiny
              child: selectTypeIcon(property.type_local),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 30.0)),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  property.type_local,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 48,
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Text("Valeur foncière: " +
                    property.valeur_fonciere.toString() +
                    " €"),
                if (property.surface_terrain != null)
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                if (property.surface_terrain != null)
                  Text("Surface terrain: " +
                      property.surface_terrain.toString() +
                      " m²"),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Text("Surface habitable: " +
                    property.surface_reelle_bati.toString() +
                    " m²"),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Text("Nombre de pièces: " +
                    property.nombre_pieces_principales.toString()),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                formatAdress(),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    border: Border.all(
                      width: 5,
                      color: Colors.orange,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text('Labels:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 36,
                        color: Colors.blue[700]!,
                      )),
                ),
              ]),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  formatAdress() {
    String res = "";
    if (property.no_voie != null) {
      res += property.no_voie.toString() + " ";
    }
    if (property.type_de_voie != null) {
      res += property.type_de_voie.toString() + " ";
    }
    if (property.voie != null) {
      res += property.voie.toString() + ", ";
    }
    if (property.code_postal != null) {
      res += property.code_postal.toString() + " ";
    }
    res += property.commune;
    return Text("Adresse: " + res);
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
