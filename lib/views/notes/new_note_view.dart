import 'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({ Key? key }) : super(key: key);

  static const routeName = '/new_note_view';

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note View'),
      ),
      body: const Text('Write your notes here...')
    );
  }
}