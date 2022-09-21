import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(String email, String password, String username, bool isLogin,
      BuildContext ctx, File? image) authForm;
  final bool isLoading;
  const AuthForm(this.authForm, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  File? _userImageFile;
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an image"),
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      widget.authForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context,
        _userImageFile,
      );
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      pickedImage: _pickedImage,
                    ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    onSaved: ((newValue) {
                      _userEmail = newValue ?? "";
                    }),
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('Username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return "Length must be grater or equal to 4 chars";
                        }
                        return null;
                      },
                      onSaved: ((newValue) {
                        _userName = newValue ?? "";
                      }),
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('Password'),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 7) {
                        return "Length must be grater or equal to 7 chars";
                      }
                      return null;
                    },
                    onSaved: ((newValue) {
                      _userPassword = newValue ?? "";
                    }),
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  SizedBox(height: 15),
                  (widget.isLoading)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? "Login" : "Register"),
                        ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Create New Account"
                            : "I alrady have an account",
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
