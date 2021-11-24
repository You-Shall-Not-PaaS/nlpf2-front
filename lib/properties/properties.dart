import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlpf2/properties/filter.dart';
import 'package:nlpf2/properties/listing.dart';
import 'package:nlpf2/properties/map.dart';
import 'package:nlpf2/service/service.dart';
import 'package:tuple/tuple.dart';

class Properties extends StatefulWidget {
  const Properties({Key? key}) : super(key: key);
  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> {
  var keyOne = GlobalKey<NavigatorState>();
  var keyTwo = GlobalKey<NavigatorState>();
  final GlobalKey<PropertyMapState> _mapKey = GlobalKey();

  Future<Tuple2<List<Property>, List<Future<Property?>>>>? _propertiesLocations;

  int _page = 1;
  final pageField = TextEditingController();
  Filters _filters = Filters();
  bool _showMap = false;

  refreshProperties() {
    _propertiesLocations = getProperties(_page, _filters);
  }

  void setFilters(Filters filters) {
    setState(() {
      _page = 1;
      _filters = filters;
      if (_mapKey.currentState != null) {
        _mapKey.currentState!.refreshMarkers();
      }
      refreshProperties();
    });
  }

  @override
  void initState() {
    refreshProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 50), //padding
      IntrinsicHeight(
          child: Navigator(
              key: keyOne,
              onGenerateRoute: (routeSettings) => MaterialPageRoute(
                  builder: (context) => FilterWidget(setFilters: setFilters)))),
      const SizedBox(height: 70), //padding
      Expanded(
          child: Navigator(
              key: keyTwo,
              onGenerateRoute: (routeSettings) => MaterialPageRoute(
                  builder: (context) => FutureBuilder<
                          Tuple2<List<Property>, List<Future<Property?>>>>(
                        future: _propertiesLocations,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _showMap
                                ? PropertyMap(
                                    key: _mapKey,
                                    propertiesLocations: snapshot.data!)
                                : Listing(properties: snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      )))),
      const SizedBox(height: 20), //padding
      ElevatedButton(
          onPressed: () {
            setState(() {
              _showMap = !_showMap;
            });
          },
          child: _showMap
              ? const Text('Revenir aux propriétés')
              : const Text('Afficher la carte')),
      const SizedBox(height: 20), //padding
      IntrinsicHeight(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              textDirection: TextDirection.rtl,
            ),
            onTap: () {
              setState(() {
                if (_page > 1) {
                  _page--;
                  refreshProperties();
                  if (_mapKey.currentState != null) {
                    _mapKey.currentState!.refreshMarkers();
                  }
                }
              });
            },
          ),
          const SizedBox(width: 20), //padding
          SizedBox(
              width: 20,
              child: TextField(
                  controller: pageField,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: _page.toString()),
                  keyboardType: TextInputType.number,
                  onSubmitted: (page) {
                    setState(() {
                      _page = int.parse(page);
                      refreshProperties();
                      pageField.clear();
                      if (_mapKey.currentState != null) {
                        _mapKey.currentState!.refreshMarkers();
                      }
                    });
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ])),
          const SizedBox(width: 20), //padding
          InkWell(
            child: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () async {
              setState(() {
                _page++;
                refreshProperties();
                if (_mapKey.currentState != null) {
                  _mapKey.currentState!.refreshMarkers();
                }
              });
            },
          ),
        ],
      )),
      const SizedBox(height: 20), //padding
    ]);
  }
}
