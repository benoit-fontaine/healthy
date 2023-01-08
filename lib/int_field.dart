// ignore_for_file: file_names

import 'package:flutter/material.dart';

class IntField extends StatelessWidget {
  final String label;
  final String suffix;
  final Future<int> initialValue;
  final void Function(int value) updateValue;
  const IntField({
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
          ? IntFieldSF(
              label: label,
              initialValue: snapshot.data ?? 0,
              suffix: suffix,
              updateValue: updateValue)
          : Container(),
    );
  }
}

class IntFieldSF extends StatefulWidget {
  final String label;
  final String suffix;
  final int initialValue;
  final void Function(int value) updateValue;
  const IntFieldSF({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.suffix,
    required this.updateValue,
  }) : super(key: key);

  @override
  State<IntFieldSF> createState() => _IntFieldSFState();
}

class _IntFieldSFState extends State<IntFieldSF> {
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
