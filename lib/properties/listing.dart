import 'package:flutter/material.dart';
import 'package:nlpf2/properties/map.dart';
import 'package:nlpf2/properties/properties.dart';
import 'package:nlpf2/service/service.dart';

/// This is the stateless widget that the main application instantiates.
class Listing extends StatefulWidget {
  const Listing({Key? key, required this.properties, required this.page})
      : super(key: key);
  final List<Property> properties;
  final int page;
  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView(
              padding: const EdgeInsets.all(8.0),
              itemExtent: 106.0,
              children: [
            for (var property in widget.properties)
              Container(
                  decoration: const BoxDecoration(
                      border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.blueGrey))),
                      child: InkWell(
                        onTap: () => showDialog(context: context, builder: (BuildContext dialogContext) {
                          return DescriptionWidget(property: property);
                          },
                        ),
                       // onTap: () => showDialog(context: context, builder: return MyAlertDialog(property: property)), // handle your onTap here
                        child: CustomListItem(property: property))),
               //   child: CustomListItem(property: property))
          ])),
      const SizedBox(height: 20), //padding
      ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PropertyMap(properties: widget.properties)));
          },
          child: const Text('Afficher la carte')),
      const SizedBox(height: 20) //padding
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

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
    title: const Text('Description du bien'),
    content:  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Type de bien: " + property.type_local),
        Text("Valeur foncière: " + property.valeur_fonciere.toString() + " €"),
        Text("Surface habitable: " + property.surface_reelle_bati.toString() + " m²"),
        if (property.surface_terrain != null)
           Text("Surface terrain: " + property.surface_terrain.toString() + " m²"),
        Text("Nombre de pièces: " + property.nombre_pieces_principales.toString()),

        formatAdress(),
        const Text("labels: "),
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

  formatAdress()
  {
    String res = "";
    if (property.no_voie != null)
    {
      res += property.no_voie.toString() + " ";
    }
    if (property.type_de_voie != null)
    {
      res += property.type_de_voie.toString() + " ";
    }
    if (property.voie != null)
    {
      res += property.voie.toString() + ", ";
    }
    if (property.code_postal != null)
    {
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
