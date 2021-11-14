import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nlpf2/properties/filter.dart';

const backURL =
    'https://us-central1-sylvan-harmony-307114.cloudfunctions.net/test1';

Future<List<Property>> getProperties(Filters? filters) async {
  return mock;
/*  final response = await http.get(Uri.parse(backURL + '/properties'));
  if (response.statusCode == 200) {
    // return mock;
    final jsonBody = jsonDecode(response.body);
    List<Property> properties = [];
    for (var property in jsonBody) {
      properties.add(Property.fromJson(property));
    }
    return properties;
  }
  throw Exception("Erreur lors de la récupération des propriétés.");*/
}

class Property {
  final int? id;
  final int? no_disposition;
  final String? date_mutation;
  final String? nature_mutation;
  final int valeur_fonciere;
  final String? no_voie;
  final String? type_de_voie;
  final String? code_voie;
  final String? voie;
  final String? code_postal;
  final String commune;
  final String? code_departement;
  final String? code_commune;
  final String? section;
  final String? no_plan;
  final String? premier_lot;
  final int? nombre_de_lots;
  final String? code_type_local;
  final String type_local;
  final int surface_reelle_bati;
  final int nombre_pieces_principales;
  final String? nature_culture;
  final int? surface_terrain;

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
      this.surface_terrain});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        id: json['id'],
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
        code_departement: json['code_departement'],
        code_commune: json['code_commune'],
        section: json['section'],
        no_plan: json['no_plan'],
        premier_lot: json['premier_lot'],
        nombre_de_lots: json['nombre_de_lots'],
        code_type_local: json['code_type_local'],
        type_local: json['type_local'],
        surface_reelle_bati: json['surface_reelle_bati'],
        nombre_pieces_principales: json['nombre_pieces_principales'],
        nature_culture: json['nature_culture'],
        surface_terrain: json['surface_terrain']);
  }
}

List<Property> mock = [
  Property(
      commune: "PARIS",
      no_voie: "3",
      type_de_voie: "rue",
      voie: "de l'eau",
      code_postal: "94682",
      type_local: "Maison",
      valeur_fonciere: 200000,
      surface_reelle_bati: 250,
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
      valeur_fonciere: 10000,
      surface_reelle_bati: 8,
      nombre_pieces_principales: 5)
];
