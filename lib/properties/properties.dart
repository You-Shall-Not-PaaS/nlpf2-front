import 'package:flutter/material.dart';
import 'package:nlpf2/properties/filter.dart';
import 'package:nlpf2/properties/listing.dart';
import 'package:nlpf2/service/service.dart';

class Properties extends StatefulWidget {
  const Properties({Key? key}) : super(key: key);
  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> {
  var keyOne = GlobalKey<NavigatorState>();
  var keyTwo = GlobalKey<NavigatorState>();
  Future<List<Property>>? _properties;

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
      IntrinsicHeight(
          child: Navigator(
              key: keyOne,
              onGenerateRoute: (routeSettings) => MaterialPageRoute(
                  builder: (context) =>
                      FilterWidget(refreshProperties: refreshProperties)))),
      Expanded(
          child: Navigator(
              key: keyTwo,
              onGenerateRoute: (routeSettings) => MaterialPageRoute(
                  builder: (context) => FutureBuilder<List<Property>>(
                        future: _properties,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Listing(properties: snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ))))
    ]);
  }
}
