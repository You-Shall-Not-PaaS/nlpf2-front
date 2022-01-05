import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nlpf2/properties/estimate.dart';
import 'package:nlpf2/properties/filter.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//const geoapifyKey = "9115835f5042473ca6063cfeb06bbd46";
const geoapifyKey = "b2d29fb4ad0345beae0c6438379c06b1";

/*const backURL =
    'https://us-central1-sylvan-harmony-307114.cloudfunctions.net/nlpf';*/

String? backURL = dotenv.env['URL'];

Future<EstimatePrice> getEstimatePrice(PropertyForm form) async {
  String type = "Maison";
  if (form.appartement) {
    type = "Appartement";
  }
  final http.Response response = await http.get(Uri.parse(
      '$backURL/properties/estimation/${form.city}/$type/${form.surface}/${form.room}/${form.garden}'));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    EstimatePrice estimatePrice = EstimatePrice.fromJson(jsonBody['data']);
    return estimatePrice;
  }
  throw Exception("Erreur lors de la récupération des biens similaires.");
}

Future<List<Property>> getSimilar(Property property) async {
  final http.Response response = await http
      .get(Uri.parse('$backURL/properties/similar/${property.id.toString()}'));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    List<Property> properties = [];
    for (var property in jsonBody['data']) {
      print(property);
      properties.add(Property.fromJson(property));
    }
    getLocations(properties);
    return properties;
  }
  throw Exception("Erreur lors de la récupération des biens similaires.");
}

Future<Label> getLabels(String id) async {
  final response =
      await http.get(Uri.parse(backURL! + "/properties-grade/" + id));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    Label label = Label.fromJson(jsonBody['data']);
    return label;
  }
  throw Exception("Erreur lors de la récupération des labels.");
}

Future<TownSpec> getAverageTownPrice(String id) async {
  final response = await http.get(
      Uri.parse(backURL! + "/properties/town/average-price/" + id.toString()));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    TownSpec townSpec = TownSpec.fromJson(jsonBody['data']);
    return townSpec;
  }
  throw Exception("Erreur lors de la récupération du prix moyen de la ville.");
}

String createFilterUri(int page, Filters filters) {
  String filterString = '?';
  if (filters.cities.isNotEmpty) {
    filterString += "&cities=";
    for (var city in filters.cities) {
      filterString += city as String;
      if (city != filters.cities.last) {
        filterString += ",";
      }
    }
  }
  if (filters.minPrice != -1) {
    filterString += "&minPrice=" + filters.minPrice.toString();
  }
  if (filters.maxPrice != -1) {
    filterString += "&maxPrice=" + filters.maxPrice.toString();
  }
  if (filters.minRooms != -1) {
    filterString += "&minRooms=" + filters.minRooms.toString();
  }
  if (filters.maxRooms != -1) {
    filterString += "&maxRooms=" + filters.maxRooms.toString();
  }
  if (filters.surfaceMin != -1) {
    filterString += "&minSize=" + filters.surfaceMin.toString();
  }
  if (filters.surfaceMax != -1) {
    filterString += "&maxSize=" + filters.surfaceMax.toString();
  }
  if (filterString != "?") {
    return backURL! + '/properties-filter/' + page.toString() + filterString;
  }

  return backURL! + '/properties/' + page.toString();
}

List<Future<Property?>> getLocations(List<Property> properties) {
  return properties
      .map((Property property) async {
        if (property.pos == null) {
          final uri =
              "https://api.geoapify.com/v1/geocode/search?text=${property.code_voie.toString()}%20${property.type_de_voie}%20${property.voie!.replaceAll(" ", "%20")}%20${property.commune.replaceAll(" ", "%20")}&apiKey=$geoapifyKey";
          final response = await http.get(Uri.parse(uri));
          if (response.statusCode == 200) {
            final jsonBody = jsonDecode(response.body);
            property.pos = LatLng(jsonBody['features'][0]['properties']['lat'],
                jsonBody['features'][0]['properties']['lon']);
          }
          return property;
        }
      })
      .whereType<Future<Property?>>()
      .toList();
}

Future<Tuple2<List<Property>, List<Future<Property?>>>> getProperties(
    int page, Filters filters) async {
  //getLocations(mock);
  //return mock;
  page--;
  final response = await http.get(Uri.parse(createFilterUri(page, filters)));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    List<Property> properties = [];
    for (var property in jsonBody['data']) {
       print(property);
      properties.add(Property.fromJson(property));
    }
    final List<Future<Property?>> locations = getLocations(properties);
    return Tuple2(properties, locations);
  }
  throw Exception("Erreur lors de la récupération des propriétés.");
}

class EstimatePrice {
  final String price;
  final String price_m;
  final int sample_size;

  EstimatePrice(
      {required this.price, required this.price_m, required this.sample_size});

  factory EstimatePrice.fromJson(Map<String, dynamic> json) {
    return EstimatePrice(
        price: json['price'],
        price_m: json['price/m2'],
        sample_size: json['sample_size']);
  }
}

class TownSpec {
  final double? average_price;
  final int? sample_size;

  TownSpec({this.average_price, this.sample_size});

  factory TownSpec.fromJson(Map<String, dynamic> json) {
    return TownSpec(
        average_price: json['average_price'], sample_size: json['sample_size']);
  }
}

class Label {
  final String grade;
  final String tag;

  Label({required this.grade, required this.tag});

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      grade: json['grade'],
      tag: json['tag'],
    );
  }
}

class Property {
  final String id;
  final String? no_disposition;
  final String? date_mutation;
  final String? nature_mutation;
  final int valeur_fonciere;
  final int? no_voie;
  final String? type_de_voie;
  final String? code_voie;
  final String? voie;
  final String? code_postal;
  final String commune;
  final int? code_departement;
  final int? code_commune;
  final String? section;
  final int? no_plan;
  final int? nombre_de_lots;
  final String? code_type_local;
  final String type_local;
  final int surface_reelle_bati;
  final int nombre_pieces_principales;
  final String? nature_culture;
  final int? surface_terrain;
  LatLng? pos;

  Property(
      {required this.id,
      this.no_disposition,
      this.date_mutation,
      this.nature_mutation,
      required this.valeur_fonciere,
      this.no_voie,
      this.type_de_voie,
      this.code_voie,
      this.voie,
      this.code_postal,
      required this.commune,
      this.code_departement,
      this.code_commune,
      this.section,
      this.no_plan,
      this.nombre_de_lots,
      this.code_type_local,
      required this.type_local,
      required this.surface_reelle_bati,
      required this.nombre_pieces_principales,
      this.nature_culture,
      this.surface_terrain,
      this.pos});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_disposition': no_disposition,
      'date_mutation': date_mutation,
      'nature_mutation': nature_mutation,
      'valeur_fonciere': valeur_fonciere,
      'no_voie': no_voie,
      'type_de_voie': type_de_voie,
      'code_voie': code_voie,
      'voie': voie,
      'code_postal': code_postal,
      'commune': commune,
      'code_departement': code_departement,
      'code_commune': code_commune,
      'section': section,
      'no_plan': no_plan,
      'nombre_de_lots': nombre_de_lots,
      'code_type_local': code_type_local,
      'type_local': type_local,
      'surface_reelle_bati': surface_reelle_bati,
      'nombre_pieces_principales': nombre_pieces_principales,
      'nature_culture': nature_culture,
      'surface_terrain': surface_terrain,
      'pos': pos
    };
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        id: json['id'].toString(),
        no_disposition: json['no_disposition'],
        date_mutation: json['date_mutation'],
        nature_mutation: json['nature_mutation'],
        valeur_fonciere: json['valeur_fonciere'],
        no_voie: json['no_voie'],
        type_de_voie: json['type_de_voie'],
        code_voie: json['code_voie'],
        voie: json['voie'],
        code_postal: json['code_postal'],
        commune: json['commune'],
        code_departement: int.parse(json['code_departement']),
        code_commune: int.parse(json['code_commune']),
        section: json['section'],
        no_plan: int.parse(json['no_plan']),
        nombre_de_lots: int.parse(json['nombre_de_lots']),
        code_type_local: json['code_type_local'],
        type_local: json['type_local'],
        surface_reelle_bati: json['surface_reelle_bati'],
        nombre_pieces_principales: json['nombre_pieces_principales'],
        nature_culture: json['nature_culture'],
        surface_terrain: json['surface_terrain']);
  }
}

/*
List<Property> mock = [
  Property(
      commune: "PARIS",
      code_postal: "94682",
      type_local: "Maison",
      code_voie: "42",
      type_de_voie: "rue",
      voie: "de Cronstadt",
      valeur_fonciere: 200000,
      surface_reelle_bati: 250,
      nombre_pieces_principales: 5),
  Property(
      commune: "ASNIERES-SUR-SEINE",
      type_local: "Appartement",
      type_de_voie: "rue",
      code_voie: "15",
      voie: "albert 1er",
      valeur_fonciere: 150000,
      surface_reelle_bati: 50,
      nombre_pieces_principales: 5),
  Property(
      commune: "CRETEIL",
      type_local: "Maison",
      type_de_voie: "avenue",
      code_voie: "42",
      voie: "Magellan",
      valeur_fonciere: 290000000,
      surface_reelle_bati: 1500,
      nombre_pieces_principales: 5),
  Property(
      commune: "Paris",
      type_local: "Appartement",
      type_de_voie: "rue",
      code_voie: "15",
      voie: "Palestro",
      valeur_fonciere: 45000,
      surface_reelle_bati: 132,
      nombre_pieces_principales: 5),
  Property(
      commune: "LYON",
      type_local: "Appartement",
      valeur_fonciere: 150000,
      surface_reelle_bati: 50,
      nombre_pieces_principales: 5),
  Property(
      commune: "PERPIZOO",
      type_local: "Maison",
      valeur_fonciere: 290000000,
      surface_reelle_bati: 1500,
      nombre_pieces_principales: 5),
  Property(
      commune: "TOULOUSE",
      type_local: "Dépendance",
      valeur_fonciere: 45000,
      surface_reelle_bati: 132,
      nombre_pieces_principales: 5),
  Property(
      commune: "TOURCOING",
      type_local: "Autres",
      valeur_fonciere: 5165,
      surface_reelle_bati: 8,
      nombre_pieces_principales: 5)
];*/
