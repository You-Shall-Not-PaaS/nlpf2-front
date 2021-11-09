import 'package:flutter/material.dart';
import 'package:nlpf2/properties/filter.dart';
import 'package:nlpf2/properties/listing.dart';

class Property {
  final String commune;
  final String type_local;
  final int valeur_fonciere;
  final int surface_reelle_bati;
  Property(
      {required this.commune,
      required this.type_local,
      required this.valeur_fonciere,
      required this.surface_reelle_bati});
}

List<Property> mock = [
  Property(
      commune: "PARIS",
      type_local: "Maison",
      valeur_fonciere: 200000,
      surface_reelle_bati: 250),
  Property(
      commune: "LYON",
      type_local: "Appartement",
      valeur_fonciere: 150000,
      surface_reelle_bati: 50),
  Property(
      commune: "PERPIZOO",
      type_local: "Maison",
      valeur_fonciere: 290000000,
      surface_reelle_bati: 1500),
  Property(
      commune: "TOULOUSE",
      type_local: "Dépendance",
      valeur_fonciere: 45000,
      surface_reelle_bati: 132),
  Property(
      commune: "TOURCOING",
      type_local: "Autres",
      valeur_fonciere: 10000,
      surface_reelle_bati: 8)
];

List<Property> getProperties(Filters? filters) {
  // appel api
  if (filters == null) return mock;
  List<Property> res = [];
  for (var property in mock) {
    if ((!filters.cities.isNotEmpty ||
            filters.cities.contains(property.commune)) &&
        property.valeur_fonciere >= filters.minPrice &&
        (filters.maxPrice == -1 ||
            property.valeur_fonciere <= filters.maxPrice)) {
      res.add(property);
    }
  }
  return res;
}

class Properties extends StatefulWidget {
  const Properties({Key? key}) : super(key: key);
  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> {
  var keyOne = GlobalKey<NavigatorState>();
  var keyTwo = GlobalKey<NavigatorState>();
  List<Property> _properties = [];

  void refreshProperties(Filters filters) {
    setState(() {
      _properties = getProperties(filters);
    });
  }

  @override
  void initState() {
    super.initState();
    _properties = getProperties(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Navigator(
              key: keyOne,
              onGenerateRoute: (routeSettings) => MaterialPageRoute(
                  builder: (context) =>
                      FilterWidget(refreshProperties: refreshProperties)))),
      Expanded(
          child: Navigator(
              key: keyTwo,
              onGenerateRoute: (routeSettings) => MaterialPageRoute(
                  builder: (context) => Listing(properties: _properties))))
    ]);
  }
}
