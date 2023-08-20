import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.color,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: color,
      ),
      child: Text(
        text,
      ),
    );
  }
}
