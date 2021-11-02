import 'package:flutter/material.dart';
import 'package:nlpf2/properties/filter.dart';
import 'package:nlpf2/properties/listing.dart';

class Property {
  final int price;
  final String city;
  Property({required this.price, required this.city});
}

List<Property> mock = [
  Property(price: 100, city: "Paris"),
  Property(price: 50, city: "Lyon"),
];

List<Property> getProperties(Filters? filters) {
  // appel api
  if (filters == null) return mock;
  List<Property> res = [];
  for (var property in mock) {
    if ((!filters.cities.isNotEmpty ||
            filters.cities.contains(property.city)) &&
        property.price >= filters.minPrice &&
        (filters.maxPrice == -1 || property.price <= filters.maxPrice)) {
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
