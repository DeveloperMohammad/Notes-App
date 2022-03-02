import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;

import '/services/crud/notes_service.dart';
import '/utilities/dialogs/logout_dialog.dart';
import '/views/login_view.dart';
import 'create_update_note_view.dart';
import '/views/notes/notes_list_view.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  static const routeName = 'notes_view';

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
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
                  devtools.log(showLogout.toString());
                  if (showLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginView.routeName,
                      (_) => false,
                    );
                  } else {
                    devtools.log('an error occurred');
                  }
                  break;
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        devtools.log(allNotes.toString());
                        return NotesListView(
                          notes: allNotes,
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              CreateOrUpdateNoteView.routeName,
                              arguments: note,
                            );
                          },
                          onDeleteNote: (note) async {
                            await _notesService.deleteNote(id: note.id);
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
