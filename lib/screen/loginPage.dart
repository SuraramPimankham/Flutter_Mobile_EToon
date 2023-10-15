import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apptoon/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Duration loginTime = Duration(milliseconds: 2250);

  Future<String?> signUp(String? email, String? password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );

      await FirebaseFirestore.instance.collection('users').add({
        'username': email ?? '',
        'email': email,
        'password': password,
        'coin': 0,
        'favorite': null,
      });

      return null; // Successful sign-up
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      return errorMessage;
    }
  }

  Future<String?> signIn(String? email, String? password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );

      // เมื่อล็อกอินสำเร็จ, บันทึกข้อมูลการล็อกอินลงใน SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'E-Toon',
      logo: AssetImage('images/logo1.png'),
      onLogin: (data) async {
        print('User email: ${data.name}, password: ${data.password}');
        return await signIn(data.name, data.password);
      },
      onSignup: (data) async {
        return await signUp(data.name, data.password);
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            // สร้าง GoogleAuthProvider instance
            var googleProvider = GoogleAuthProvider();

            try {
              // ล็อกอินผ่านบัญชี Google
              UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithPopup(googleProvider);
              return null;
            } catch (e) {
              // หากเกิดข้อผิดพลาดในการล็อกอิน
              print('Google Sign In Error: $e');
              return 'เกิดข้อผิดพลาดในการล็อกอิน';
            }
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          label: 'Facebook',
          callback: () async {
            debugPrint('start facebook sign in');
            await Future.delayed(loginTime);
            debugPrint('stop facebook sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      },
      onRecoverPassword: (name) async {
        return await _recoverPassword(name);
      },
    );
  }
}
