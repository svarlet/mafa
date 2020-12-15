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
                return LoadingSharedPreferences();
              } else {
                return SharedPreferencesTable(snapshot.data);
              }
            }));
  }
}

class LoadingSharedPreferences extends StatelessWidget {
  static const message = 'Fetching shared preferences...';

  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}

class SharedPreferencesTable extends StatelessWidget {
  static const tableHeader = TableRow(children: [Text('Key'), Text('Value')]);

  final SharedPreferences sharedPreferences;

  SharedPreferencesTable(this.sharedPreferences);

  List<TableRow> _renderDataRows(SharedPreferences prefs) {
    return prefs
        .getKeys()
        .map((e) => MapEntry(e, prefs.get(e)))
        .where((aMapEntry) => aMapEntry.value is String)
        .map((aMapEntry) => MapEntry(aMapEntry.key, aMapEntry.value as String))
        .map(_asTableRow)
        .toList();
  }

  TableRow _asTableRow(MapEntry<String, String> aMapEntry) {
    return TableRow(children: [
      Text(aMapEntry.key),
      Text(aMapEntry.value, overflow: TextOverflow.ellipsis)
    ]);
  }

  Widget build(BuildContext context) {
    return Table(
        children: [tableHeader, ..._renderDataRows(this.sharedPreferences)]);
  }
}
