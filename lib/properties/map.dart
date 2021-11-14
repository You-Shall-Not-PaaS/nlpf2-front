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

  @override
  void initState() {
    super.initState();
    widget.properties.forEach((property) {
      if (property.pos != null) {
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
                child: const Icon(Icons.pin_drop_sharp, color: Colors.red))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: FlutterMap(
        options: MapOptions(
          center: LatLng(48.8566, 2.3522),
          zoom: 13.0,
        ),
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
