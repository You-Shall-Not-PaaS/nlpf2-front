import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:nlpf2/service/service.dart';
import 'package:tuple/tuple.dart';

import 'listing.dart';

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget(
      {Key? key, required this.property, required this.similarKey})
      : super(key: key);
  final Property property;
  final GlobalKey<NavigatorState> similarKey;
  @override
  State<DescriptionWidget> createState() => _DescriptionWidget();
}

class _DescriptionWidget extends State<DescriptionWidget> {
  Future<Label>? _label;
  Future<TownSpec>? _townSpec;

  @override
  void initState() {
    _label = getLabels(widget.property.id);
    _townSpec = getAverageTownPrice(widget.property.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CloseButton(
                color: const Color(0xFFD5D3D3),
                onPressed: () {
                  if (widget.similarKey.currentContext != null) {
                    Navigator.of(widget.similarKey.currentContext!,
                            rootNavigator: true)
                        .pop();
                  }
                  Navigator.pop(context);
                })
          ]),
      titlePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      content: FutureBuilder<Label>(
        future: _label,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    constraints: const BoxConstraints.expand(
                        width: 250.0, height: 250.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: selectTypeIcon(widget.property.type_local),
                    ),
                  ),
                  Container(
                      constraints: const BoxConstraints.expand(
                          width: 550.0, height: 250.0),
                      child: Column(children: <Widget>[
                        Text(
                          typeLocal(widget.property.type_local),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.property.valeur_fonciere.toString() + " €",
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 50.0)),
                            Text(
                              "Note: " +
                                  snapshot.data!.grade.toString() +
                                  "/10",
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0)),
                        Container(
                            margin: const EdgeInsets.only(left: 50.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.room_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.0)),
                                      formatAdress(),
                                    ],
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7.0)),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.meeting_room,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.0)),
                                      Text(
                                        widget.property
                                                .nombre_pieces_principales
                                                .toString() +
                                            " pièces",
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7.0)),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.zoom_out_map_rounded,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.0)),
                                      if (widget.property.surface_terrain !=
                                          null)
                                        Text(
                                          "Terrain: " +
                                              widget.property.surface_terrain
                                                  .toString() +
                                              " m²",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      Text(
                                        "     Bâtie: " +
                                            widget.property.surface_reelle_bati
                                                .toString() +
                                            " m²",
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ])),
                      ])),
                ],
              ),
              Row(children: [
                Container(
                    alignment: Alignment.topLeft,
                    constraints: const BoxConstraints.expand(
                        width: 290.0, height: 100.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Labels:",
                              style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline),
                            )),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0)),
                        Row(
                          children: [
                            for (Tuple2<String, String> tag
                                in parseLabels(snapshot.data!.tag))
                              Container(
                                  decoration: colorDecoration(tag.item2),
                                  margin: const EdgeInsets.only(left: 4.0),
                                  child: Text(tag.item1)),
                          ],
                        )
                      ],
                    )),
                FutureBuilder<TownSpec>(
                  future: _townSpec,
                  builder: (context, snapshottown) {
                    if (snapshottown.hasData) {
                      return Container(
                          constraints: const BoxConstraints.expand(
                              width: 270.0, height: 100.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (widget.property.surface_reelle_bati != 0)
                                  Text("Moyenne bien: " +
                                      (widget.property.valeur_fonciere /
                                              widget
                                                  .property.surface_reelle_bati)
                                          .round()
                                          .toString() +
                                      " €/m²"),
                                if (snapshottown.data!.average_price != null)
                                  Text("Moyenne ville: " +
                                      snapshottown.data!.average_price
                                          .toString() +
                                      " €/m²"),
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0)),
                                if (widget.property.surface_reelle_bati != 0 &&
                                    snapshottown.data!.average_price != null)
                                  Text(
                                    "Moyenne calculée sur " +
                                        snapshottown.data!.sample_size
                                            .toString() +
                                        " propriétés",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  )
                              ]));
                    } else if (snapshottown.hasError) {
                      return Text('${snapshottown.error}');
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    constraints: const BoxConstraints.expand(
                        width: 240.0, height: 100.0),
                    child: ElevatedButton(
                        onPressed: _lookForAgence,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[500],
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        child: const Text('Agences à proximité'))),
              ]),
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  void _lookForAgence() async {
    html.window.open(
        'https://www.google.com/maps/search/agences+immobilières/@${widget.property.pos!.latitude},${widget.property.pos!.longitude},14z',
        'new tab');
  }

  String typeLocal(String type) {
    if (type == "Local industriel. commercial ou assimilé") {
      return "Local";
    } else {
      return type;
    }
  }

  colorDecoration(String level) {
    switch (level) {
      case "Bon":
        {
          return BoxDecoration(
            color: Colors.green,
            border: Border.all(
              width: 4,
              color: Colors.green,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          );
        }
      case "Ok":
        {
          return BoxDecoration(
            color: Colors.yellow,
            border: Border.all(
              width: 4,
              color: Colors.yellow,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          );
        }
      case "Mauvais":
        {
          return BoxDecoration(
            color: Colors.orange,
            border: Border.all(
              width: 4,
              color: Colors.orange,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          );
        }
      case "Neutre":
        {
          return BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              width: 4,
              color: Colors.blue,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          );
        }
    }
  }

  parseLabels(String tag) {
    List<Tuple2<String, String>> res = [];
    if (tag.isEmpty) {
      return res;
    }
    var tab = tag.split(";");
    for (var i = 0; i < tab.length; i++) {
      var tmp = tab[i].split(",");
      var t = Tuple2<String, String>(tmp[0], tmp[1]);
      res.add(t);
    }
    return res;
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
    return Text(
      res,
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }
}
