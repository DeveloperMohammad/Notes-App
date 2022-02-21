import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/utilities/show_error_dialog.dart';
import 'package:notes/views/verify_email_view.dart';

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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(LoginView.routeName);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await showErrorDialog(
                      context: context,
                      title: 'Register Error',
                      content: 'The password you entered is weak');
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(
                      context: context,
                      title: 'Register Error',
                      content: 'Email is Already in use');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(
                      context: context,
                      title: 'Register Error',
                      content: 'Email is Invalid');
                } else if (e.code == 'network-request-failed') {
                  await showErrorDialog(
                      context: context,
                      title: 'Register Error',
                      content: 'Failed to connect to internet');
                } else {
                  await showErrorDialog(
                      context: context,
                      title: 'Register Error',
                      content: 'Error: ${e.code}');
                }
              } catch (e) {
                await showErrorDialog(
                    context: context,
                    title: 'Unknown error',
                    content: e.toString());
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
