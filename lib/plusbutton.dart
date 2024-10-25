import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;

  const PlusButton({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  offset: const Offset(4.0, 4.0)),
              const BoxShadow(
                  color: Colors.white,
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  offset: Offset(-4.0, -4.0)),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
