import 'package:apptoon/Pages/favoritepage.dart';
import 'package:apptoon/Pages/homepage.dart';
import 'package:apptoon/profile.dart';
import 'package:apptoon/Pages/profilepage.dart';
import 'package:apptoon/Pages/tablepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptoon/screen/loginPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggedIn = false;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//HomePageState
class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  @override
  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogged = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      widget.isLoggedIn = isLogged;
    });
  }

  void initState() {
    super.initState();
    // ตรวจสอบสถานะการล็อกอินและกำหนดค่าให้กับ isLoggedIn
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
      setState(() {
        widget.isLoggedIn = user != null;
      });
    });
  }

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
          MyFavoritePage(),
          widget.isLoggedIn
              ? MyProfilePage(email: widget._auth.currentUser?.email)
              : MyProfile(),
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
          Icon(Icons.favorite, size: 30),
          Icon(Icons.person, size: 30),
        ],
      ),
    );
  }
}
