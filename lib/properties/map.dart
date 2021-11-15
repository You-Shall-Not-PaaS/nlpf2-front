import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nlpf2/service/service.dart';

class PropertyMap extends StatefulWidget {
  const PropertyMap({Key? key, required this.properties}) : super(key: key);
  final List<Property> properties;
  @override
  State<PropertyMap> createState() => _PropertyMapState();
}

class _PropertyMapState extends State<PropertyMap> {
  List<Marker> _markers = [];

  int _markerNumber = 0;
  double _avgLat = 0;
  double _avgLon = 0;
  double _minLon = 360;
  double _maxLon = 0;
  double _minLat = 360;
  double _maxLat = 0;

  @override
  void initState() {
    widget.properties.forEach((property) {
      if (property.pos != null) {
        final lat = property.pos!.latitude;
        final lon = property.pos!.longitude;
        _markerNumber++;
        _avgLat += lat;
        _avgLon += lon;
        _minLon = _minLon < lon + 180 ? _minLon : lon + 180;
        _maxLon = _maxLon > lon + 180 ? _maxLon : lon + 180;
        _minLat = _minLat < lat + 180 ? _minLat : lat + 180;
        _maxLat = _maxLat > lat + 180 ? _maxLat : lat + 180;
        _markers.add(Marker(
            width: 80.0,
            height: 80.0,
            point: property.pos ?? LatLng(0, 0),
            builder: (ctx) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopUp(property: property)));
                },
                child: Tooltip(
                    padding: const EdgeInsets.all(10),
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.white),
                    message: property.type_local +
                        "   " +
                        property.surface_reelle_bati.toString() +
                        "m²   " +
                        property.valeur_fonciere.toString() +
                        "€",
                    child:
                        const Icon(Icons.pin_drop_sharp, color: Colors.red)))));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: FlutterMap(
        options: MapOptions(
            center: LatLng(_avgLat / _markerNumber, _avgLon / _markerNumber),
            zoom: (_maxLon - _minLon) > (_maxLat - _minLat)
                ? (_maxLon - _minLon) * 20
                : (_maxLat - _minLat)),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            attributionBuilder: (_) {
              return const Text("© OpenStreetMap contributors");
            },
          ),
          MarkerLayerOptions(markers: _markers),
        ],
      )),
      const SizedBox(height: 20), //padding
      IntrinsicHeight(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hide The Map'))),
      const SizedBox(height: 20), //padding
    ]);
  }
}

class PopUp extends StatelessWidget {
  const PopUp({Key? key, required this.property}) : super(key: key);
  final Property property;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Property"),
        ),
        body: Center(
            child: Column(children: [
          Text(
              "price: " +
                  property.valeur_fonciere.toString() +
                  " city: " +
                  property.commune,
              style: const TextStyle(fontSize: 20)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("go back"),
          ),
        ])));
  }
}
