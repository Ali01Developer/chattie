import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx, File? image) async {
    setState(() {
      _isLoading = true;
    });
    try {
      late UserCredential authResult;
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${authResult.user?.uid}.jpg');

        await storageRef.putFile(image!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user?.uid)
            .set(
          {
            'userName': username,
            'email': email,
            'image_url': imageUrl,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLogin ? "User Logged In" : "User Registered !"),
        ),
      );
    } on FirebaseException catch (err) {
      var message = "Wrong credentials !!!";

      if (err.message != null) {
        message = err.message ?? "";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
