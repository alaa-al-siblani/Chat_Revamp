import 'dart:io';

import 'package:chat_revamp/widgets/image_picking.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function _submitForm;
  final bool _isLoading;
  const AuthForm(this._submitForm, this._isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  var isLogin = true;
  var username = '';
  var email = '';
  var password = '';
  File? _pickedImage;

  void tryLogin(BuildContext ctx) {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();
      widget._submitForm(_pickedImage, username.trim(), email.trim(),
          password.trim(), isLogin, ctx);
    }
  }

  void setImage(File image) {
    _pickedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLogin == false) ImagePick(setImage),
                      if (isLogin == false)
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Write a username';
                            }
                            return null;
                          },
                          key: const ValueKey("username"),
                          decoration:
                              const InputDecoration(labelText: "Username"),
                          onSaved: (newValue) {
                            username = newValue!;
                          },
                        ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Write a valid email';
                          }
                          return null;
                        },
                        key: const ValueKey("email"),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: "Email"),
                        onSaved: (newValue) {
                          email = newValue!;
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.length < 7) {
                            return 'Write a longer password';
                          }
                          return null;
                        },
                        key: const ValueKey("password"),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration:
                            const InputDecoration(labelText: "Password"),
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (widget._isLoading == true)
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      if (widget._isLoading == false)
                        ElevatedButton(
                          onPressed: () {
                            tryLogin(context);
                          },
                          child: isLogin == true
                              ? const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 19),
                                )
                              : const Text(
                                  'Signup',
                                  style: TextStyle(fontSize: 19),
                                ),
                        ),
                      if (widget._isLoading == false)
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: isLogin == true
                                ? const Text(
                                    'Create an account',
                                    style: TextStyle(fontSize: 15),
                                  )
                                : const Text(
                                    'Login instead',
                                    style: TextStyle(fontSize: 15),
                                  ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
