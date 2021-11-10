import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nlpf2/service/cities.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key, required this.refreshProperties})
      : super(key: key);
  final Function(Filters filters) refreshProperties;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class Filters {
  int minPrice = -1;
  int maxPrice = -1;
  int minRooms = -1;
  int maxRooms = -1;
  int surfaceMin = -1;
  int surfaceMax = -1;
  List<Object?> cities = [];
}

class _FilterWidgetState extends State<FilterWidget> {
  final Filters _filters = Filters();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      MultiSelectDialogField(
          items: cities
              .map((city) => MultiSelectItem<String>(city, city))
              .toList(),
          title: const Text('Villes'),
          buttonText: const Text("Villes"),
          //selectedColor: Colors.purple,
          listType: MultiSelectListType.LIST,
          searchable: true,
          onConfirm: (values) {
            setState(() {
              _filters.cities = values;
            });
            widget.refreshProperties(_filters);
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              setState(() {
                _filters.cities.remove(value);
              });
              widget.refreshProperties(_filters);
            },
          )),
      SizedBox(
          width: 80,
          child: TextField(
              decoration: const InputDecoration(labelText: "Prix Min"),
              keyboardType: TextInputType.number,
              onSubmitted: (minPrice) {
                setState(() {
                  _filters.minPrice = int.parse(minPrice);
                });
                widget.refreshProperties(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      SizedBox(
          width: 80,
          child: TextField(
              decoration: const InputDecoration(labelText: "Prix Max"),
              keyboardType: TextInputType.number,
              onSubmitted: (maxPrice) {
                setState(() {
                  _filters.maxPrice = int.parse(maxPrice);
                });
                widget.refreshProperties(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      SizedBox(
          width: 100,
          child: TextField(
              decoration: const InputDecoration(labelText: "Nb Pièce Min"),
              keyboardType: TextInputType.number,
              onSubmitted: (minRooms) {
                setState(() {
                  _filters.minRooms = int.parse(minRooms);
                });
                widget.refreshProperties(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      SizedBox(
          width: 100,
          child: TextField(
              decoration: const InputDecoration(labelText: "Nb Pièce Max"),
              keyboardType: TextInputType.number,
              onSubmitted: (maxRooms) {
                setState(() {
                  _filters.maxRooms = int.parse(maxRooms);
                });
                widget.refreshProperties(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
    ]);
  }
}
