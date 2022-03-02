import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) async {
  return showGenericDialog<void>(
    context: context,
    title: 'An Error Ocurred',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
