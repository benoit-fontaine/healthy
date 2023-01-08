import 'package:flutter/material.dart';
import 'package:healthy/int_field.dart';
import 'package:healthy/bool_field.dart';
import 'package:healthy/double_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Healthy: Macro-nutriments'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _taille = 0;
  double _poids = 0;
  int _age = 0;
  double _activite = 0;
  bool _homme = true;
  double _deficit = 0;

  final _varsHomme = [13.707, 492.3, 6.673, 77.607];
  final _varsFemme = [9.74, 172.9, 4.7373, 667.051];

  double kcalByActivity() {
    if (_activite < 2) return 1.375;
    if (_activite < 4) return 1.56;
    if (_activite < 7) return 1.64;
    return 1.82;
  }

  double protByActivity() {
    if (_activite < 2) return 0.8 * _poids;
    if (_activite < 4) return 1.6 * _poids;
    return 2 * _poids;
  }

  double glucides() {
    return (calcKcal() - (protByActivity() * 4) - (_poids * 9)) / 4;
  }

  int calcKcal() {
    double result = 0;
    var vars = _homme ? _varsHomme : _varsFemme;
    result += vars[0] * _poids;
    result += vars[1] * (_taille / 100);
    result += vars[2] * _age;
    result += vars[3] * kcalByActivity();
    return result.round() - _deficit.round();
  }

  void setActivite(double value) {
    setState(() {
      _activite = value;
    });
    _prefs.then((SharedPreferences prefs) {
      prefs.setDouble('activite', value);
    });
  }

  void setPoids(double value) {
    setState(() {
      _poids = value;
    });
    _prefs.then((SharedPreferences prefs) {
      prefs.setDouble('poids', value);
    });
  }

  void setTaille(int value) {
    setState(() {
      _taille = value;
    });
    _prefs.then((SharedPreferences prefs) {
      prefs.setInt('taille', value);
    });
  }

  void setAge(int value) {
    setState(() {
      _age = value;
    });
    _prefs.then((SharedPreferences prefs) {
      prefs.setInt('age', value);
    });
  }

  void setHomme(bool value) {
    setState(() {
      _homme = value;
    });
    _prefs.then((SharedPreferences prefs) {
      prefs.setBool('homme', value);
    });
  }

  Future<bool> getBoolPref(String name) =>
      _prefs.then((SharedPreferences prefs) => prefs.getBool(name) ?? true);

  Future<int> getIntPref(String name) =>
      _prefs.then((SharedPreferences prefs) => prefs.getInt(name) ?? 0);

  Future<double> getDoublePref(String name) =>
      _prefs.then((SharedPreferences prefs) => prefs.getDouble(name) ?? 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 36.0),
            child: IntField(
              initialValue: getIntPref("taille"),
              label: "Taille",
              suffix: "cm",
              updateValue: (value) => setTaille(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 36.0),
            child: DoubleField(
              initialValue: getDoublePref("poids"),
              label: "Poids",
              suffix: "kg",
              updateValue: (value) => setPoids(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 36.0),
            child: IntField(
              initialValue: getIntPref("age"),
              label: "Âge",
              suffix: "ans",
              updateValue: (value) => setAge(value),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(left: 36.0, right: 36.0, top: 20.0),
              child: null),
          BoolField(
            labelTrue: "Homme",
            labelFalse: "Femme",
            initialValue: getBoolPref("homme"),
            updateValue: (value) => setHomme(value),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 36.0, right: 36.0, top: 36.0),
              child: Text(
                "Activités intenses par semaine",
                style: Theme.of(context).textTheme.titleSmall,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 36.0),
            child: Slider(
              value: _activite,
              max: 7,
              divisions: 3,
              label: _activite.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _activite = value;
                });
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "${calcKcal()} kcal",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "Calories",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "${protByActivity().round().toString()} g",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "Protéines",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "${glucides().round()} g",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "Glucides",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "${_poids.round()} g",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "Lipides",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.green),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 36.0),
            child: Slider(
              value: _deficit,
              max: 700,
              activeColor: Colors.green,
              onChanged: (double value) {
                setState(() {
                  _deficit = value;
                });
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "Déficit calorique",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.green),
              )),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
