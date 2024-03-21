import 'package:flutter/material.dart';

class AdditionalInfomation extends StatelessWidget {
  final IconData iconfav;
  final String label;
  final String value;
  const AdditionalInfomation(
      {super.key,
      required this.iconfav,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          iconfav,
          size: 38,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
