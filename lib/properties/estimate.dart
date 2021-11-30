import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:nlpf2/properties/description.dart';
import 'package:nlpf2/service/cities.dart';
import 'package:nlpf2/service/service.dart';

import 'listing.dart';

class Estimation extends StatefulWidget {
  const Estimation({Key? key}) : super(key: key);
  @override
  State<Estimation> createState() => _Estimation();
}

class PropertyForm {
  bool maison = false;
  bool appartement = false;
  String city = "";
  String surface = "0";
  String room = "0";
  String garden = "0";
}

class _Estimation extends State<Estimation> {
  final _formKey = GlobalKey<FormState>();
  final PropertyForm form = PropertyForm();
  Future<EstimatePrice>? _estimate;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 500),
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: <Widget>[
              DropdownSearch<String>(
                validator: (v) => v == null ? "required field" : null,
                dropdownSearchDecoration: const InputDecoration(
                  hintText: "Choisissez une ville",
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: OutlineInputBorder(),
                ),
                mode: Mode.MENU,
                showSelectedItems: true,
                showSearchBox: true,
                items: cities,
                showClearButton: true,
                onChanged: (value) {
                  setState(() {
                    form.city = value.toString();
                  });
                },
                clearButtonSplashRadius: 20,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
              const Text("Type de bien:"),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Row(children: [
                  SizedBox(
                    width: 10,
                    child: Checkbox(
                      value: form.maison,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          form.maison = !form.maison;
                          if (form.appartement) {
                            form.appartement = false;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text('MAISON'),
                ]),
                Row(children: [
                  SizedBox(
                    width: 10,
                    child: Checkbox(
                      value: form.appartement,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          form.appartement = !form.appartement;
                          if (form.maison) {
                            form.maison = false;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text('APPARTEMENT'),
                ]),
              ]),
              Column(children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Surface bâtie en m²',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 32.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0))),
                  onChanged: (value) {
                    form.surface = value;
                  },
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Nombre de pièces',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 32.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0))),
                  onChanged: (value) {
                    form.room = value;
                  },
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Surface jardin en m²',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 32.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0))),
                  onChanged: (value) {
                    form.garden = value;
                  },
                ),
              ]),
              const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _estimate = getEstimatePrice(form);
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PriceWidget(form: form);
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
}

class PriceWidget extends StatefulWidget {
  const PriceWidget({Key? key, required this.form}) : super(key: key);
  final PropertyForm form;
  @override
  State<PriceWidget> createState() => _PriceWidget();
}

class _PriceWidget extends State<PriceWidget> {
  Future<EstimatePrice>? _estimate;

  @override
  void initState() {
    _estimate = getEstimatePrice(widget.form);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CloseButton(
                  color: const Color(0xFFD5D3D3),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ]),
        titlePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        content: FutureBuilder<EstimatePrice>(
          future: _estimate,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  priceDisplay(snapshot.data!.sample_size,
                      snapshot.data!.price_m, snapshot.data!.price),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ));
  }

  priceDisplay(int size, String pricem, String price) {
    String type = "Maison";
    if (widget.form.appartement) {
      type = "Appartement";
    }
    if (size == -1) {
      return const Text("Pas assez de valeurs");
    } else {
      return Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          alignment: Alignment.topCenter,
          constraints: const BoxConstraints.expand(width: 250.0, height: 250.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: selectTypeIcon(type),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
        Container(
          constraints: const BoxConstraints.expand(width: 250.0, height: 250.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Estimation :",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 35,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text("Prix éstimé: " + price + " €"),
              const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
              Text("Prix au m²: " + pricem + " €/m²"),
              const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
              Text(
                "Calculé avec: " + size.toString() + " données",
                style: const TextStyle(
                  fontSize: 11,
                ),
              )
            ],
          ),
        ),
      ]);
    }
  }
}
