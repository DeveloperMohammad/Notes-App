import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
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
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      setState(() => isLoading = false);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          HomePage.routeName, (route) => false);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        // if user credential is wrong
                        await showErrorDialog(
                            context: context,
                            title: 'Login Error',
                            content: 'The email you entered doesn\'t exist');
                        setState(() => isLoading = false);
                      } else if (e.code == 'wrong-password') {
                        // if password entered is wrong
                        await showErrorDialog(
                            context: context,
                            title: 'Login Error',
                            content: 'The password you entered is incorret');
                        setState(() => isLoading = false);
                      } else if (e.code == 'network-request-failed') {
                        // if your internet connection fails
                        await showErrorDialog(
                            context: context,
                            title: 'Network Issue',
                            content: 'Your connection time out!');
                        setState(() => isLoading = false);
                      } else {
                        await showErrorDialog(
                            context: context,
                            title: 'Error',
                            content: 'Error: ${e.code}');
                        setState(() => isLoading = false);
                      }
                    } catch (e) {
                      await showErrorDialog(
                          context: context,
                          title: 'Error',
                          content: e.toString());
                      setState(() => isLoading = false);
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
