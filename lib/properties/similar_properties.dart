import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nlpf2/properties/listing.dart';
import 'package:nlpf2/service/service.dart';

/// This is the stateless widget that the main application instantiates.
class Similar extends StatefulWidget {
  const Similar({Key? key, required this.property, required this.dialogKey})
      : super(key: key);
  final GlobalKey<NavigatorState> dialogKey;
  final Property property;
  @override
  State<Similar> createState() => _SimilarState();
}

class _SimilarState extends State<Similar> {
  Future<List<Property>>? _similarProperties;

  @override
  void initState() {
    _similarProperties = getSimilar(widget.property);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Property>>(
      future: _similarProperties,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomList(
              properties: snapshot.data!, dialogKey: widget.dialogKey);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class MyCustomScrollBehavior extends ScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class CustomList extends StatelessWidget {
  const CustomList(
      {Key? key, required this.properties, required this.dialogKey})
      : super(key: key);
  final List<Property> properties;
  final GlobalKey<NavigatorState> dialogKey;
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            children: [
              for (var property in properties)
                Row(children: [
                  const SizedBox(width: 10),
                  Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Card(
                          child: InkWell(
                              child: CustomListItem(property: property),
                              onTap: () => {
                                    if (dialogKey.currentContext != null)
                                      {
                                        Navigator.of(dialogKey.currentContext!,
                                            rootNavigator: true)
                                      },
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                    openPropertyDialog(context, property)
                                  }))),
                  const SizedBox(width: 10),
                ])
            ]));
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({Key? key, required this.property}) : super(key: key);

  final Property property;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 100, child: selectTypeIcon(property.type_local)),
          Expanded(
            child: _PropertyDetails(
              property: property,
            ),
          )
        ],
      ),
    );
  }
}

class _PropertyDetails extends StatelessWidget {
  const _PropertyDetails({Key? key, required this.property}) : super(key: key);

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          property.type_local,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        Text(
          property.commune,
          style: const TextStyle(fontSize: 16.0),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
        Text(
          '${property.valeur_fonciere} ???',
          style: const TextStyle(fontSize: 16.0),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
        Text(
          '${property.surface_reelle_bati} m??',
          style: const TextStyle(fontSize: 16.0),
        )
      ],
    );
  }
}
