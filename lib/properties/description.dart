import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlpf2/service/service.dart';

import 'listing.dart';

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget({Key? key, required this.property}) : super(key: key);
  final Property property;
  @override
  State<DescriptionWidget> createState() => _DescriptionWidget();
}

class _DescriptionWidget extends State<DescriptionWidget> {
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
              child: selectTypeIcon(widget.property.type_local),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 30.0)),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.property.type_local,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 48,
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Text("Valeur foncière: " +
                    widget.property.valeur_fonciere.toString() +
                    " €"),
                if (widget.property.surface_terrain != null)
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                if (widget.property.surface_terrain != null)
                  Text("Surface terrain: " +
                      widget.property.surface_terrain.toString() +
                      " m²"),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Text("Surface habitable: " +
                    widget.property.surface_reelle_bati.toString() +
                    " m²"),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Text("Nombre de pièces: " +
                    widget.property.nombre_pieces_principales.toString()),
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
    if (widget.property.no_voie != null) {
      res += widget.property.no_voie.toString() + " ";
    }
    if (widget.property.type_de_voie != null) {
      res += widget.property.type_de_voie.toString() + " ";
    }
    if (widget.property.voie != null) {
      res += widget.property.voie.toString() + ", ";
    }
    if (widget.property.code_postal != null) {
      res += widget.property.code_postal.toString() + " ";
    }
    res += widget.property.commune;
    return Text("Adresse: " + res);
  }
}