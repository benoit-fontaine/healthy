import 'package:flutter/material.dart';

class DoubleField extends StatelessWidget {
  final String label;
  final String suffix;
  final Future<double> initialValue;
  final void Function(double value) updateValue;
  const DoubleField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.suffix,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialValue,
      builder: (context, snapshot) => (snapshot.hasData)
          ? DoubleFieldSF(
              label: label,
              initialValue: snapshot.data ?? 0,
              suffix: suffix,
              updateValue: updateValue)
          : Container(),
    );
  }
}

class DoubleFieldSF extends StatefulWidget {
  final String label;
  final String suffix;
  final double initialValue;
  final void Function(double value) updateValue;
  const DoubleFieldSF({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.suffix,
    required this.updateValue,
  }) : super(key: key);

  @override
  State<DoubleFieldSF> createState() => _DoubleFieldSFState();
}

class _DoubleFieldSFState extends State<DoubleFieldSF> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(widget.label),
        suffix: Text(widget.suffix),
        errorText: _errorText,
      ),
      initialValue: "${widget.initialValue}",
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Merci de renseigner';
        }
        if (int.tryParse(value) == null) {
          return 'Il faut saisir un chiffre';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          var newState = double.tryParse(value);
          if (value.isEmpty) {
            _errorText = 'Merci de renseigner';
          } else if (newState == null) {
            _errorText = 'Il faut saisir un nombre';
          } else {
            widget.updateValue(newState);
            _errorText = null;
          }
        });
      },
    );
  }
}
