import 'package:flutter/material.dart';
import 'package:healthy/edit_form.dart';
import 'package:healthy/model/health_imput.dart';
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
  double _deficit = 0;
  double _activite = 0;
  double _poids = 0;
  int _age = 0;
  int _taille = 0;
  bool _estUnHomme = true;

  final _varsHomme = [13.707, 492.3, 6.673, 77.607];
  final _varsFemme = [9.74, 172.9, 4.7373, 667.051];

  double getLipides() => _poids;

  double getFacteurActivite() {
    if (_activite < 2) return 1.375;
    if (_activite < 4) return 1.56;
    if (_activite < 7) return 1.64;
    return 1.82;
  }

  double getProteines() {
    if (_activite < 2) return 0.8 * _poids;
    if (_activite < 4) return 1.6 * _poids;
    return 2 * _poids;
  }

  double getGlucides() => (getCKal() - (getProteines() * 4) - (_poids * 9)) / 4;

  double getCKal() {
    double cKal = 0;
    var vars = _estUnHomme ? _varsHomme : _varsFemme;
    cKal += vars[0] * _poids;
    cKal += vars[1] * (_taille / 100);
    cKal += vars[2] * _age;
    cKal += vars[3] * getFacteurActivite();
    cKal = cKal - _deficit.round();
    return cKal;
  }

  Future<HealthInput> getPrefs() async {
    HealthInput result = await _prefs.then(
      (pref) => pref.reload().then(
            (value) => HealthInput(
              activite: pref.getDouble(SharedLabel.activite) ?? 0,
              age: pref.getInt(SharedLabel.age) ?? 0,
              estHomme: pref.getBool(SharedLabel.estUnHomme) ?? true,
              poids: pref.getDouble(SharedLabel.poids) ?? 0,
              taille: pref.getInt(SharedLabel.taille) ?? 0,
            ),
          ),
    );
    setState(() {
      _activite = result.activite;
      _age = result.age;
      _estUnHomme = result.estHomme;
      _poids = result.poids;
      _taille = result.taille;
    });
    return result;
  }

  void setPref(String prefLabel, HealthInput input) async {
    SharedPreferences pref = await _prefs;
    if (prefLabel == SharedLabel.activite) {
      pref.setDouble(
        prefLabel,
        input.activite,
      );
      setState(() {
        _activite = input.activite;
      });
    }
    if (prefLabel == SharedLabel.age) {
      pref.setInt(
        prefLabel,
        input.age,
      );
      setState(() {
        _age = input.age;
      });
    }
    if (prefLabel == SharedLabel.poids) {
      pref.setDouble(
        prefLabel,
        input.poids,
      );
      setState(() {
        _poids = input.poids;
      });
    }
    if (prefLabel == SharedLabel.taille) {
      pref.setInt(
        prefLabel,
        input.taille,
      );
      setState(() {
        _taille = input.taille;
      });
    }
    if (prefLabel == SharedLabel.estUnHomme) {
      pref.setBool(
        prefLabel,
        input.estHomme,
      );
      _estUnHomme = input.estHomme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            EditForm(
                title: widget.title,
                healthInput: getPrefs(),
                onChanged: setPref),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                      child: Text(
                        "${getCKal().round()} kcal",
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
                        "${getProteines().round().toString()} g",
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
                        "${getGlucides().round()} g",
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
                        "${getLipides().round()} g",
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
                ]),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
