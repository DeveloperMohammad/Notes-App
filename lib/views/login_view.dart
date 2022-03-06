import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/services/auth/auth_exceptions.dart';
import '/services/auth/bloc/auth_bloc.dart';
import '/services/auth/bloc/auth_event.dart';
import '../utilities/dialogs/error_dialog.dart';
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
                      context.read<AuthBloc>().add(
                            AuthEventLogin(
                              email: email,
                              password: password,
                            ),
                          );
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        'The email you entered doesn\'t exist',
                      );
                      setState(() => isLoading = false);
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'The password you entered is incorret',
                      );
                      setState(() => isLoading = false);
                    } on NetworkRequestFailedAuthException {
                      await showErrorDialog(
                        context,
                        'Your connection time out!',
                      );
                      setState(() => isLoading = false);
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Authentication Error',
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
