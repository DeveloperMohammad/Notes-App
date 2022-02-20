import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.option1,
  }) : super(key: key);

  final String title;
  final String content;
  final String option1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(option1),
        ),
        // TextButton(
        //   onPressed: () {
        //     Navigator.pop(context, true);
        //   },
        //   child: Text(option2),
        // )
      ],
    );
  }
}
