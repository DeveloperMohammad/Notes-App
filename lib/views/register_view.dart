import 'package:flutter/material.dart';

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
    return Scaffold(
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
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(LoginView.routeName);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'The password you entered is weak',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email is Already in use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Email is Invalid',
                );
              } on NetworkRequestFailedAuthException {
                await showErrorDialog(
                  context,
                  'Failed to connect to internet',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to Register',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginView.routeName, (route) => false);
            },
            child: const Text('Already Registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
