import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {

  final String text;

  const GridItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {

    return Container(

      alignment: Alignment.center,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),

      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}