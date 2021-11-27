import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nlpf2/properties/filter.dart';
import 'package:tuple/tuple.dart';

const geoapifyKey = "ba7327de7fe34f90818b38e7da9b982e";

const backURL =
    'https://us-central1-sylvan-harmony-307114.cloudfunctions.net/nlpf';

Future<List<Property>> getSimilar(Property property) async {
  final http.Response response = await http
      .get(Uri.parse('$backURL/properties/similar/${property.id.toString()}'));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    List<Property> properties = [];
    for (var property in jsonBody['data']) {
      properties.add(Property.fromJson(property));
    }
    return properties;
  }
  throw Exception("Erreur lors de la récupération des biens similaires.");
}

Future<Label> getLabels(String id) async {
  final response = await http.get(Uri.parse(
      "https://us-central1-sylvan-harmony-307114.cloudfunctions.net/notebien/properties-grade/" +
          id.toString()));
  //await http.get(Uri.parse(backURL + "/properties-grade/" + id.toString()));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    Label label = Label.fromJson(jsonBody);
    return label;
  }
  throw Exception("Erreur lors de la récupération des labels.");
}

Future<int> getAverageTownPrice(String id) async {
  final response = await http.get(
      Uri.parse(backURL + "/properties/town/average-price/" + id.toString()));
  //Uri.parse(backURL + "/properties/town/average-price/" + id.toString()));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    return jsonBody['average_price'];
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
    return backURL + '/properties-filter/' + page.toString() + filterString;
  }

  return backURL + '/properties/' + page.toString();
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
      properties.add(Property.fromJson(property));
    }
    final List<Future<Property?>> locations = getLocations(properties);
    return Tuple2(properties, locations);
  }
  throw Exception("Erreur lors de la récupération des propriétés.");
}

class Label {
  final int grade;

  Label({required this.grade});

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(grade: json['grade']);
  }
}

class Property {
  final String? id;
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
  final int? premier_lot;
  final int? nombre_de_lots;
  final String? code_type_local;
  final String type_local;
  final int surface_reelle_bati;
  final int nombre_pieces_principales;
  final String? nature_culture;
  final int? surface_terrain;
  LatLng? pos;

  Property(
      {this.id,
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
      this.premier_lot,
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
      'premier_lot': premier_lot,
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
        id: json['id'],
        no_disposition: json['No disposition'],
        date_mutation: json['Date mutation'],
        nature_mutation: json['Nature mutation'],
        valeur_fonciere: json['Valeur fonciere'],
        no_voie: json['No voie'],
        type_de_voie: json['Type de voie'],
        code_voie: json['Code voie'],
        voie: json['Voie'],
        code_postal: json['Code postal'],
        commune: json['Commune'],
        code_departement: json['Code departement'],
        code_commune: json['Code commune'],
        section: json['Section'],
        no_plan: json['No plan'],
        premier_lot: json['1er lot'],
        nombre_de_lots: json['Nombre de lots'],
        code_type_local: json['Code type local'],
        type_local: json['Type local'],
        surface_reelle_bati: json['Surface reelle bati'],
        nombre_pieces_principales: json['Nombre pieces principales'],
        nature_culture: json['Nature culture'],
        surface_terrain: json['Surface terrain']);
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
