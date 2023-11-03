// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chat_revamp/widgets/auth_form.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../firebase/user.dart' as user;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;
  void _submitForm(File? pickedImage, String username, String email,
      String password, bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String? url;
        if (pickedImage != null) {
          url = await user.User.saveImage(pickedImage);
        }

        user.User.addUser(username, email, url);
      }
      isLoading = false;
    } on FirebaseAuthException catch (e) {
      var mess = 'An error occurred, please check your credentials!';
      if (e.code == 'email-already-in-use') {
        mess = 'This email address is already in use by another account!';
      }

      Scaffold.of(ctx).showBottomSheet((context) => Container(
            width: double.infinity,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            child: Text(
              mess,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ));

      setState(() {
        isLoading = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(ctx).pop();
      });
    } on PlatformException catch (err) {
      var mess = 'A platform error occurred.';
      if (err.message != null) {
        mess = err.message!;
      }

      Scaffold.of(ctx).showBottomSheet((context) => Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Text(
              mess,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ));

      setState(() {
        isLoading = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(ctx).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(
        _submitForm,
        isLoading,
      ),
    );
  }
}
