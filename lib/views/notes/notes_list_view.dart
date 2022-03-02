import 'package:flutter/material.dart';

import '/utilities/dialogs/delete_dialog.dart';
import '../../services/crud/notes_service.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  const NotesListView(
      {Key? key, required this.notes, required this.onDeleteNote})
      : super(key: key);

  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if(shouldDelete) {
                onDeleteNote(note);
              }
            },
          ),
        );
      },
    );
  }
}
