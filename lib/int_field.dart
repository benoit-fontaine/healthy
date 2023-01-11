// ignore_for_file: file_names

import 'package:flutter/material.dart';

class IntField extends StatefulWidget {
  final String label;
  final String suffix;
  final int initialValue;
  final void Function(int value) updateValue;
  const IntField({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.suffix,
    required this.updateValue,
  }) : super(key: key);

  @override
  State<IntField> createState() => _IntFieldState();
}

class _IntFieldState extends State<IntField> {
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
          var newState = int.tryParse(value);
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
