import 'package:flutter/material.dart';

class BoolField extends StatefulWidget {
  final String labelTrue;
  final String labelFalse;
  final Future<bool> initialValue;
  final void Function(bool value) updateValue;
  const BoolField({
    Key? key,
    required this.labelTrue,
    required this.labelFalse,
    required this.initialValue,
    required this.updateValue,
  }) : super(key: key);

  @override
  State<BoolField> createState() => _BoolFieldState();
}

class _BoolFieldState extends State<BoolField> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.initialValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _selectedIndex = (snapshot.data ?? true) ? 0 : 1;

            return ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                widget.updateValue(index == 0);
                setState(() {
                  _selectedIndex = index;
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              children: <Widget>[
                Text(widget.labelTrue),
                Text(widget.labelFalse),
              ],
            );
          }
          return Container();
        });
  }
}
