import 'package:flutter/material.dart';

void customSnackBar({
  required String message,
  required BuildContext context,
  Color backgroundColor = Colors.black87,
  Color textColor = Colors.white,
  int durationInSeconds = 3,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: textColor, fontSize: 14)),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
      behavior: SnackBarBehavior.floating, // makes it float above UI
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12),
    ),
  );
}
