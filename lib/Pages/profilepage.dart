import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptoon/screen/loginPage.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signOut(context);
            },
          ),
        ],
        flexibleSpace: Container(
          alignment: Alignment.center,
          child: Container(
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
        ),
      ),
      body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              color: Colors.blue,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('users :',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    Text(
                      'coins :',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.blue,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),

                                    Text(
                                       ' : 25 coins',
                                      style: TextStyle(fontSize: 16 ,
                                          color: Colors.white,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Button presse dmitr ...');
                                },
                                 style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .pink, 
                                  elevation: 3,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '25 บาท',
                                  style: TextStyle(fontSize: 16, color: Colors.white)
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                      
                    ],
                    ),
                  
                  
                ),
              ),
            )
          ],
        )

    );
  }
}
