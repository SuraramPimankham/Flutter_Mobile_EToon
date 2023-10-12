import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptoon/screen/loginPage.dart';


class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Declare variables to store user data
  String userName = "สมหมาย ใจดี"; // Replace with actual user data

  // Method to sign out
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('My Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signOut(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'images/logo1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 229,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 129, 166),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'UserName : ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 148,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 129, 166),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              ':',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 349,
                  height: 520,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 236, 122, 158),
                  ),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    scrollDirection: Axis.vertical,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 25',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '25 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 50',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '50 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 75',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '75 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 100',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '100 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 125',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '125 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 150',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '150 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 175',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '175 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFE4DAE4), // สีพื้นหลังของการ์ด
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text(
                                      'เหรียญ : 200',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white, // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.black, // สีเส้นกั้น
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color(0xFFD453F2), // สีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '200 บาท',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white, // สีข้อความบนปุ่ม
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
