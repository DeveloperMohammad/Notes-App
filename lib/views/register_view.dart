import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';

import '/services/auth/auth_exceptions.dart';
import '/services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';
import '/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      if(state is AuthStateRegistering) {
        if(state.exception is WeakPasswordAuthException) {
          await showErrorDialog(context, 'Weak Password');
        } else if(state.exception is EmailAlreadyInUseAuthException) {
          await showErrorDialog(context, 'Email is Already in use');
        } else if(state.exception is InvalidEmailAuthException) {
          await showErrorDialog(context, 'Weak Password');
        } else if(state.exception is NetworkRequestFailedAuthException) {
          await showErrorDialog(context, 'Weak Password');
        } else if(state.exception is GenericAuthException){
          await showErrorDialog(context, '${state.exception}');
        }
      }
    },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
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
                context.read<AuthBloc>().add(AuthEventRegister(email: email, password: password));
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogout());
              },
              child: const Text('Already Registered? Login here!'),
            ),
          ],
        ),
      ),
    );
  }
}
