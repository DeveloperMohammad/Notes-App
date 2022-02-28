import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/views/notes/notes_view.dart';
import 'package:notes/views/verify_email_view.dart';

import '../utilities/show_error_dialog.dart';
import '../views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TextField(
                  controller: _emailController,
                  enableSuggestions: true,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() => isLoading = true);
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );
                      final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          NotesView.routeName,
                          (route) => false,
                        );
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          VerifyEmailView.routeName,
                          (route) => false,
                        );
                      }
                      setState(() => isLoading = false);
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context: context,
                        title: 'Login Error',
                        content: 'The email you entered doesn\'t exist',
                      );
                      setState(() => isLoading = false);
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context: context,
                        title: 'Login Error',
                        content: 'The password you entered is incorret',
                      );
                      setState(() => isLoading = false);
                    } on NetworkRequestFailedAuthException {
                      await showErrorDialog(
                        context: context,
                        title: 'Network Issue',
                        content: 'Your connection time out!',
                      );
                      setState(() => isLoading = false);
                    } on GenericAuthException {
                      await showErrorDialog(
                        context: context,
                        title: 'Error',
                        content: 'Authentication Error',
                      );
                      setState(
                        () => isLoading = false,
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RegisterView.routeName,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Not registered yet? Register here!',
                  ),
                ),
              ],
            ),
    );
  }
}
