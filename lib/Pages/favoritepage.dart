import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage();

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to My App! mitr Coins',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
              height: 20), // เพิ่มระยะห่างระหว่างข้อความและ Container หมวดหมู่
          Container(
            height: 250,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('storys').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('เกิดข้อผิดพลาด: ${snapshot.error.toString()}'),
                  );
                }
                final documents = snapshot.data?.docs;

                if (documents == null || documents.isEmpty) {
                  return Center(
                    child: Text('ไม่พบข้อมูลใน collection "storys"'),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    final data = document.data() as Map<String, dynamic>;
                    final title = data['title'];
                    final day = data['day'];
                    final imageUrl = data['imageUrl'];

                    return GestureDetector(
                      onTap: () {
                        _showImageDetails(context, title, day, imageUrl);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Image.network(
                                  imageUrl,
                                  width:
                                      170, // You can adjust the width as needed
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Title: $title'),
                                    Text('Day: $day'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDetails(
      BuildContext context, String title, String day, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              Text('Title: $title'),
              Text('Day: $day'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Next'),
            )
          ],
        );
      },
    );
  }
}
