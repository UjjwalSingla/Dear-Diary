import 'package:deardiary/view/dairylogview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as auth_ui;
import 'package:flutter/material.dart';

class LogInView extends StatelessWidget {
  const LogInView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return auth_ui.SignInScreen(
              providers: [
                auth_ui.EmailAuthProvider(),
              ],
            );
          }
          return const DiaryLogView();
        });
  }
}
