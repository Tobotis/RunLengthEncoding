import 'package:flutter/material.dart';

class TextSlider extends StatelessWidget {
  final int value;
  final Function(int) onChanged;
  final String title;
  final int max;
  final int min;
  const TextSlider(
      {Key? key,
      required this.value,
      this.title = "",
      required this.onChanged,
      required this.max,
      required this.min})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Slider(
          divisions: max - min,
          value: value.toDouble(),
          label: value.toString(),
          min: min.toDouble(),
          max: max.toDouble(),
          onChanged: (double val) => onChanged(val.toInt()),
        ),
      ],
    );
  }
}
