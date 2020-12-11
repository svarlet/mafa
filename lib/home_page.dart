import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _sharedPreferences;

  @override
  void initState() {
    super.initState();
    _sharedPreferences = SharedPreferences.getInstance()
      ..then((sharedPrefs) => sharedPrefs.setString('foo', 'bar'))
      ..then((sharedPrefs) => sharedPrefs.setString('bar',
          'baaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaz'));
  }

  List<DataRow> _renderDataRows(SharedPreferences prefs) {
    return prefs
        .getKeys()
        .map((e) => MapEntry(e, prefs.get(e)))
        .where((aMapEntry) => aMapEntry.value is String)
        .map((aMapEntry) => MapEntry(aMapEntry.key, aMapEntry.value as String))
        .map(_asDataRow)
        .toList();
  }

  DataRow _asDataRow(MapEntry<String, String> aMapEntry) {
    return DataRow(cells: [
      DataCell(Text(aMapEntry.key)),
      DataCell(Text(aMapEntry.value))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<SharedPreferences>(
            future: _sharedPreferences,
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Fetching shared preferences...'));
              } else {
                return Column(children: [
                  Expanded(
                      child: DataTable(columns: [
                    DataColumn(label: Text('Key')),
                    DataColumn(label: Text('Value')),
                  ], rows: _renderDataRows(snapshot.data)))
                ]);
              }
            }));
  }
}
