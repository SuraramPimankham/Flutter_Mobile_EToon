import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptoon/Pages/detailpage.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage();

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  String activeButton = 'action'; // เริ่มต้นด้วยหมวดหมู่ 'action'
  Map<String, String> categoryMap = {
    'action': 'action',
    'comedy': 'comedy',
    'fantasy': 'fantasy',
    'horror': 'horror',
    'romance': 'romance',
  };

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> storyData = [];

  @override
  void initState() {
    super.initState();
    fetchStoryData(activeButton); // เรียกดึงข้อมูลสำหรับ activeButton เริ่มต้น
  }

  Future<void> fetchStoryData(String? category) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('stories')
          .where('category', isEqualTo: category) // ค้นหาตามหมวดหมู่
          .where('favorite', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          storyData.clear();
        });

        querySnapshot.docs.forEach((doc) {
          storyData.add({
            'id': doc.id,
            'author': doc['author'],
            'title': doc['title'],
            'imageUrl': doc['imageUrl'],
            'description': doc['description'],
          });
        });
      } else {
        setState(() {
          storyData.clear();
        });
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการดึงข้อมูล: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการที่มีการถูกใจ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(     
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _buildButton('action', activeButton == 'action'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _buildButton('comedy', activeButton == 'comedy'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _buildButton('fantasy', activeButton == 'fantasy'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _buildButton('horror', activeButton == 'horror'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _buildButton('romance', activeButton == 'romance'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(5),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      constraints: BoxConstraints(minHeight: 600),
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: storyData.map((data) {
                          return GestureDetector(
                            onTap: () {
                              print('ID: ${data['id']}');
                              print('Author: ${data['author']}');
                              print('Title: ${data['title']}');
                              print('ImageUrl: ${data['imageUrl']}');
                              print('Description: ${data['description']}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    id: data['id'],
                                    author: data['author'],
                                    title: data['title'],
                                    imageUrl: data['imageUrl'],
                                    description: data['description'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width - 40) / 3,
                              height: 200,
                              child: Align(
                                alignment: Alignment.center,
                                child: Card(
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            data['imageUrl'],
                                            fit: BoxFit.cover,
                                            height: 140,
                                            width: 100,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            data['title'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeButton = text;
          fetchStoryData(categoryMap[text]);
        });
      },
      child: Container(
        width: 90,
        height: 45,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color:
              isActive ? Colors.pink : const Color.fromARGB(255, 237, 123, 161),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
