import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/utilities/dialogs/loading_dialog.dart';

import '../services/auth/bloc/auth_state.dart';
import '/services/auth/auth_exceptions.dart';
import '/services/auth/bloc/auth_bloc.dart';
import '/services/auth/bloc/auth_event.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User Not Found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credential Error');
          } else if (state.exception is NetworkRequestFailedAuthException) {
            await showErrorDialog(context, 'Cannot connect to the internet');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
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
                final email = _emailController.text;
                final password = _passwordController.text;
                context.read<AuthBloc>().add(
                      AuthEventLogin(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              child: const Text(
                'Not registered yet? Register here!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
