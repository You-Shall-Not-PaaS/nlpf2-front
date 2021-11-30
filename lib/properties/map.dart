import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nlpf2/properties/listing.dart';
import 'package:nlpf2/service/service.dart';
import 'package:tuple/tuple.dart';

class PropertyMap extends StatefulWidget {
  const PropertyMap({Key? key, required this.propertiesLocations})
      : super(key: key);
  final Tuple2<List<Property>, List<Future<Property?>>> propertiesLocations;
  @override
  State<PropertyMap> createState() => PropertyMapState();
}

class PropertyMapState extends State<PropertyMap> {
  List<Marker> _markers = [];
  int _markerNumber = 0;
  double _avgLat = 0;
  double _avgLon = 0;
  double _minLon = 360;
  double _maxLon = 0;
  double _minLat = 360;
  double _maxLat = 0;
  double _zoom = 12;
  LatLng _center = LatLng(48.8589466, 2.2769952);
  late MapController _mapController = MapController();

  getMarkers() {
    _markerNumber = 0;
    _avgLat = 0;
    _avgLon = 0;
    _minLon = 360;
    _maxLon = 0;
    _minLat = 360;
    _maxLat = 0;
    List<Marker> res = widget.propertiesLocations.item1
        .map((property) {
          if (property.pos != null) {
            //Zoom & Center Compute
            final lat = property.pos!.latitude;
            final lon = property.pos!.longitude;
            _markerNumber++;
            _avgLat += lat;
            _avgLon += lon;
            _minLon = _minLon < lon + 180 ? _minLon : lon + 180;
            _maxLon = _maxLon > lon + 180 ? _maxLon : lon + 180;
            _minLat = _minLat < lat + 180 ? _minLat : lat + 180;
            _maxLat = _maxLat > lat + 180 ? _maxLat : lat + 180;

            //Marker
            return Marker(
                width: 80.0,
                height: 80.0,
                point: property.pos ?? LatLng(0, 0),
                builder: (ctx) => InkWell(
                    onTap: () => openPropertyDialog(context, property),
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
                        child: const Icon(Icons.pin_drop_sharp,
                            color: Colors.red))));
          }
        })
        .whereType<Marker>()
        .toList();

    _zoom = (_maxLon - _minLon) > (_maxLat - _minLat)
        ? 12 - (_maxLon - _minLon)
        : 12 - (_maxLat - _minLat);
    _center = LatLng(_avgLat / _markerNumber, _avgLon / _markerNumber);
    return res;
  }

  refreshMarkers() async {
    setState(() {
      _markers = [];
    });
    await Future.delayed(const Duration(milliseconds: 500));
    await Future.wait(widget.propertiesLocations.item2);
    setState(() {
      _markers = getMarkers();
    });
    await _mapController.onReady;
    _mapController = MapController();
    _mapController.move(_center, _zoom);
  }

  @override
  void initState() {
    setState(() {
      refreshMarkers();
      /*
      Timer.periodic(
          const Duration(seconds: 1),
          (Timer t) => setState(() {
                List<Marker> tempMark = getMarkers();
                if (!listEquals(tempMark, _markers)) {
                  _markers = tempMark;
                  _mapController.move(_center, _zoom);
                }
              }));*/
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _markers.isEmpty
        ? Column(children: const [
            Expanded(child: SizedBox()),
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
            Expanded(child: SizedBox()),
          ])
        : Expanded(
            child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(center: _center, zoom: _zoom),
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
          ));
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
