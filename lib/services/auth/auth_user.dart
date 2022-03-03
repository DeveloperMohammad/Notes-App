import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.id,
  }); 

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified,
        id: user.uid,
      );
}
