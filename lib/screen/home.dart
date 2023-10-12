import 'package:apptoon/Pages/coinpage.dart';
import 'package:apptoon/Pages/homepage.dart';
import 'package:apptoon/Pages/profilepage.dart';
import 'package:apptoon/Pages/tablepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptoon/screen/login.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//HomePageState
class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  // เมธอดสำหรับออกจากระบบ
  void signOut(BuildContext context) async {
    await widget._auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: <Widget>[
          MyHomePage(),
          MyTablePage(),
          MyCoinPage(),
          MyProfilePage()
        ],
      ),
      // CurvedNavigationBar
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.table_chart, size: 30),
          Icon(Icons.monetization_on, size: 30),
          Icon(Icons.person, size: 30),
        ],
      ),
    );
  }
}
