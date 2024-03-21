import 'package:flutter/material.dart';

class HourForcast extends StatelessWidget {
  final String time;
  final IconData icons;
  final String temp;
  const HourForcast(
      {super.key, required this.time, required this.icons, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: SizedBox(
        width: 100,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 6,
              ),
              Icon(
                icons,
                size: 28,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                temp,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
