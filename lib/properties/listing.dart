import 'package:flutter/material.dart';
import 'package:nlpf2/properties/description.dart';
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
    return Center(
        child: FractionallySizedBox(
            widthFactor: 0.84,
            child: ListView(
                padding: const EdgeInsets.all(8.0),
                itemExtent: 200.0,
                children: [
                  for (var property in widget.properties.item1)
                    Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.blueGrey,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                            onTap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return DescriptionWidget(
                                        property: property);
                                  },
                                ),
                            // onTap: () => showDialog(context: context, builder: return MyAlertDialog(property: property)), // handle your onTap here
                            child: CustomListItem(property: property))),
                  //   child: CustomListItem(property: property))
                ])));
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
