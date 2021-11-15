import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlpf2/properties/filter.dart';
import 'package:nlpf2/properties/listing.dart';
import 'package:nlpf2/service/service.dart';

class Properties extends StatefulWidget {
  const Properties({Key? key}) : super(key: key);
  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> {
  var keyOne = GlobalKey<NavigatorState>();
  var keyTwo = GlobalKey<NavigatorState>();
  Future<List<Property>>? _properties;
  int _page = 0;
  final pageField = TextEditingController();
  Filters _filters = Filters();

  void setFilters(Filters filters) {
    setState(() {
      _filters = filters;
      _properties = getProperties(_page, _filters);
    });
  }

  @override
  void initState() {
    super.initState();
    _properties = getProperties(_page, _filters);
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
                  builder: (context) => FutureBuilder<List<Property>>(
                        future: _properties,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Listing(
                                properties: snapshot.data!, page: _page);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      )))),
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
                if (_page > 0) {
                  _page--;
                  _properties = getProperties(_page, _filters);
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
                      _properties = getProperties(_page, _filters);
                      pageField.clear();
                    });
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ])),
          const SizedBox(width: 20), //padding
          InkWell(
            child: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              setState(() {
                _page++;
                _properties = getProperties(_page, _filters);
              });
            },
          ),
        ],
      )),
      const SizedBox(height: 20), //padding
    ]);
  }
}
