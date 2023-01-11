import 'package:flutter/material.dart';
import 'package:healthy/model/health_imput.dart';

import 'bool_field.dart';
import 'double_field.dart';
import 'int_field.dart';

class EditForm extends StatelessWidget {
  final String title;
  final Future<HealthInput> healthInput;
  final void Function(String label, HealthInput value) onChanged;
  const EditForm({
    super.key,
    required this.title,
    required this.healthInput,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: healthInput,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            HealthInput data = snapshot.data ?? const HealthInput();
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                ),
                child: Column(children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 36.0, right: 36.0),
                          child: IntField(
                            initialValue: data.taille,
                            label: "Taille",
                            suffix: "cm",
                            updateValue: (value) => onChanged(
                              SharedLabel.taille,
                              data.copyWith(taille: value),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 36.0, right: 36.0),
                          child: DoubleField(
                            initialValue: data.poids,
                            label: "Poids",
                            suffix: "kg",
                            updateValue: (value) => onChanged(
                              SharedLabel.poids,
                              data.copyWith(poids: value),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 36.0, right: 36.0),
                          child: IntField(
                            initialValue: data.age,
                            label: "Âge",
                            suffix: "ans",
                            updateValue: (value) => onChanged(
                              SharedLabel.age,
                              data.copyWith(age: value),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: BoolField(
                            labelTrue: "Homme",
                            labelFalse: "Femme",
                            initialValue: data.estHomme,
                            updateValue: (value) => onChanged(
                              SharedLabel.estUnHomme,
                              data.copyWith(estHomme: value),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 36.0, right: 36.0, top: 36.0),
                    child: Text(
                      "Activités intenses par semaine",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                    child: Slider(
                      value: data.activite,
                      max: 7,
                      divisions: 3,
                      label: data.activite.round().toString(),
                      thumbColor: Colors.white,
                      activeColor: Colors.deepOrange,
                      inactiveColor: Colors.white,
                      onChanged: (double value) {
                        onChanged(
                          SharedLabel.activite,
                          data.copyWith(activite: value),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            );
          }
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.white),
              ),
            ),
          );
        });
  }
}
