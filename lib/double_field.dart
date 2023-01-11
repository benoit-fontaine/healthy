import 'package:flutter/material.dart';

class DoubleField extends StatefulWidget {
  final String label;
  final String suffix;
  final double initialValue;
  final void Function(double value) updateValue;
  const DoubleField({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.suffix,
    required this.updateValue,
  }) : super(key: key);

  @override
  State<DoubleField> createState() => _DoubleFieldState();
}

class _DoubleFieldState extends State<DoubleField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(
          widget.label,
          style: const TextStyle(color: Colors.white),
        ),
        suffix: Text(
          widget.suffix,
          style: const TextStyle(color: Colors.white),
        ),
        errorText: _errorText,
      ),
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
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
