import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('Okay'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}