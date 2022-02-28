import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/notes/new_note_view.dart';
import 'views/notes/notes_view.dart';
import 'views/register_view.dart';
import 'views/verify_email_view.dart';
import 'services/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        LoginView.routeName: (context) => const LoginView(),
        NotesView.routeName: (context) => const NotesView(),
        RegisterView.routeName: (context) => const RegisterView(),
        VerifyEmailView.routeName: (context) => const VerifyEmailView(),
        NewNoteView.routeName: (context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
