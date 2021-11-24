import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nlpf2/service/cities.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key, required this.setFilters}) : super(key: key);
  final Function(Filters filters) setFilters;

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
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
            widget.setFilters(_filters);
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              setState(() {
                _filters.cities.remove(value);
              });
              widget.setFilters(_filters);
            },
          )),
      const SizedBox(width: 60), //padding
      SizedBox(
          width: 80,
          child: TextField(
              decoration: const InputDecoration(labelText: "Prix Min"),
              keyboardType: TextInputType.number,
              onSubmitted: (minPrice) {
                setState(() {
                  if (minPrice == "") {
                    _filters.minPrice = -1;
                  } else {
                    _filters.minPrice = int.parse(minPrice);
                  }
                });
                widget.setFilters(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      const SizedBox(width: 20), //padding
      SizedBox(
          width: 80,
          child: TextField(
              decoration: const InputDecoration(labelText: "Prix Max"),
              keyboardType: TextInputType.number,
              onSubmitted: (maxPrice) {
                setState(() {
                  if (maxPrice == "") {
                    _filters.maxPrice = -1;
                  } else {
                    _filters.maxPrice = int.parse(maxPrice);
                  }
                });
                widget.setFilters(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      const SizedBox(width: 60), //padding
      SizedBox(
          width: 100,
          child: TextField(
              decoration: const InputDecoration(labelText: "Nb Pièce Min"),
              keyboardType: TextInputType.number,
              onSubmitted: (minRooms) {
                setState(() {
                  if (minRooms == "") {
                    _filters.minRooms = -1;
                  } else {
                    _filters.minRooms = int.parse(minRooms);
                  }
                });
                widget.setFilters(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      const SizedBox(width: 20), //padding
      SizedBox(
          width: 100,
          child: TextField(
              decoration: const InputDecoration(labelText: "Nb Pièce Max"),
              keyboardType: TextInputType.number,
              onSubmitted: (maxRooms) {
                setState(() {
                  if (maxRooms == "") {
                    _filters.maxRooms = -1;
                  } else {
                    _filters.maxRooms = int.parse(maxRooms);
                  }
                });
                widget.setFilters(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      const SizedBox(width: 60), //padding
      SizedBox(
          width: 100,
          child: TextField(
              decoration: const InputDecoration(labelText: "Surface Min"),
              keyboardType: TextInputType.number,
              onSubmitted: (surfaceMin) {
                setState(() {
                  if (surfaceMin == "") {
                    _filters.surfaceMin = -1;
                  } else {
                    _filters.surfaceMin = int.parse(surfaceMin);
                  }
                });
                widget.setFilters(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      const SizedBox(width: 20), //padding
      SizedBox(
          width: 100,
          child: TextField(
              decoration: const InputDecoration(labelText: "Surface Max"),
              keyboardType: TextInputType.number,
              onSubmitted: (surfaceMax) {
                setState(() {
                  if (surfaceMax == "") {
                    _filters.surfaceMax = -1;
                  } else {
                    _filters.surfaceMax = int.parse(surfaceMax);
                  }
                });
                widget.setFilters(_filters);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ])),
      const SizedBox(width: 20), //padding
    ]);
  }
}
