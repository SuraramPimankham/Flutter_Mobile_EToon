import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({Key? key}) : super(key: key);

  @override
  State<MyFavoritePage> createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'all '),
    Tab(text: 'action'),
    Tab(text: 'comedy'),
    Tab(text: 'fantasy'),
    Tab(text: 'horror'),
    Tab(text: 'romance'),
  ];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;
    if (user != null) {
      uid = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) {
      return Center(
        child: Text('ท่านยังไม่มีการเข้าสู่ระบบ'),
      );
    }

    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text('รายการที่มีการถูกใจ'),
            bottom: TabBar(
              tabs: myTabs,
              isScrollable: true, // เพิ่มค่า isScrollable นี้
            ),
          ),
          body: TabBarView(
            children: [
              buildGridView('all', uid),
              Center(child: Text('เนื้อหาแท็บ action')),
              Center(child: Text('เนื้อหาแท็บ comedy')),
              Center(child: Text('เนื้อหาแท็บ fantasy')),
              Center(child: Text('เนื้อหาแท็บ horror')),
              Center(child: Text('เนื้อหาแท็บ romance')),
            ],
          )),
    );
  }

  Widget buildGridView(String category, String uid) {
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('users').doc(uid).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (userSnapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาด: ${userSnapshot.error}'));
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
        }

        // ดึงข้อมูลจาก field 'favorite' ใน collection 'users'
        List<dynamic> favoriteIds = userSnapshot.data!['favorite'] ?? [];

        return FutureBuilder<QuerySnapshot>(
          future: firestore
              .collection('storys')
              .where('id', whereIn: favoriteIds)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('ไม่พบรายการที่ถูกใจ'));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final storyData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                // คำนวณขนาดของรูปภาพ
                double imageWidth = 200; // กำหนดความกว้างของรูปภาพ
                double imageHeight = 150; // กำหนดความสูงของรูปภาพ

                return GestureDetector(
                  onTap: () {
                    // ทำงานที่คุณต้องการเมื่อ Card ถูกคลิก
                    print('Card tapped: ${storyData['id']}');
                  },
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15.0)),
                          child: Image.network(
                            storyData['imageUrl'],
                            width: double
                                .infinity, // ทำให้รูปภาพมีความกว้างเท่ากับ Card
                            height: 150, // กำหนดความสูงของรูปภาพ
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            storyData['title'],
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
