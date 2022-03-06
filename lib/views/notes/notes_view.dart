import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

import 'dart:developer' as devtools show log;

import '/services/auth/bloc/auth_bloc.dart';
import '/services/auth/bloc/auth_event.dart';
import '/utilities/dialogs/logout_dialog.dart';
import '/views/login_view.dart';
import 'create_update_note_view.dart';
import '/views/notes/notes_list_view.dart';
import '/enums/menu_action.dart';
import '/services/auth/auth_service.dart';
import '/services/cloud/firebase_cloud_storage.dart';
import '/services/cloud/cloud_note.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  static const routeName = 'notes_view';

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CreateOrUpdateNoteView.routeName);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final showLogout = await showLogOutDialog(context);
                  if (showLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: const Text('Log Out'),
                  onTap: () {},
                )
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      CreateOrUpdateNoteView.routeName,
                      arguments: note,
                    );
                  },
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
