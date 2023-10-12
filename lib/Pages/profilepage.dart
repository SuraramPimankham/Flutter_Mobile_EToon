import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptoon/screen/login.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key});

  // เมธอดสำหรับออกจากระบบ
  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app), // ไอคอน Logout
            onPressed: () {
              // เรียกเมธอด signOut เมื่อกดปุ่ม
              signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to My App! mitr Profile',
              style: TextStyle(fontSize: 24),
            ),
            // สามารถเพิ่มข้อมูลโปรไฟล์ของผู้ใช้ได้ที่นี่
          ],
        ),
      ),
    );
  }
}
