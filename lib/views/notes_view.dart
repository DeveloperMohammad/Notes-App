import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;

import 'package:notes/views/login_view.dart';
import '../enums/menu_action.dart';
import '../services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  static const routeName = 'notes_view';

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes View'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final showLogout = await showLogoutDialog(context);
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
      body: const Center(
        child: Text(
          'Done',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: const Text('Are you sure to log out of your account?'),
      title: const Text('Log out'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Log out'),
        )
      ],
    ),
  ).then((value) => value ?? false);
}
