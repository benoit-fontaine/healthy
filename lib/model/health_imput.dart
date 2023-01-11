class HealthInput {
  final bool estHomme;
  final double activite;
  final double poids;
  final int age;
  final int taille;

  const HealthInput({
    this.estHomme = true,
    this.activite = 0,
    this.poids = 0,
    this.age = 0,
    this.taille = 0,
  });

  bool get calculPossible {
    return (taille != 0 && poids != 0 && age != 0);
  }

  HealthInput copyWith({
    bool? estHomme,
    double? activite,
    double? poids,
    int? age,
    int? taille,
  }) =>
      HealthInput(
        estHomme: estHomme ?? this.estHomme,
        activite: activite ?? this.activite,
        poids: poids ?? this.poids,
        age: age ?? this.age,
        taille: taille ?? this.taille,
      );
}

class SharedLabel {
  static String get age => "age";
  static String get activite => "activite";
  static String get poids => "poids";
  static String get taille => "taille";
  static String get estUnHomme => "homme";
}
