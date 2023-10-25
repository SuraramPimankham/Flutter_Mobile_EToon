import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptoon/Pages/detailpage.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage();

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  String activeGenre =
      'แอ็กชัน'; // กำหนดค่าเริ่มต้นให้ activeGenre เป็น 'แอ็กชัน'

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Firestore instance
  List<Map<String, dynamic>> favoriteData = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteData(
        activeGenre); // เรียกใช้งาน fetchFavoriteData เมื่อเริ่มต้น
  }

  Future<void> fetchFavoriteData(String genre) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('favorite_stories')
          .where('genre', isEqualTo: genre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          favoriteData.clear(); // ล้างข้อมูล favoriteData ที่มีอยู่
        });

        querySnapshot.docs.forEach((doc) {
          favoriteData.add({
            'id': doc['id'],
            'author': doc['author'],
            'title': doc['title'],
            'imageUrl': doc['imageUrl'],
            'description': doc['description'],
          });
        });
      } else {
        setState(() {
          favoriteData.clear(); // ล้างข้อมูล favoriteData ในกรณีที่ไม่มีข้อมูล
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการถูกใจ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          // ส่วนหมวดหมู่
          child: Column(
            children: [
              // ส่วนของปุ่มหมวดหมู่
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGenreButton('แอ็กชัน', activeGenre == 'แอ็กชัน'),
                      _buildGenreButton('โรแมนติก', activeGenre == 'โรแมนติก'),
                      _buildGenreButton('ตลก', activeGenre == 'ตลก'),
                      _buildGenreButton('แฟนตาซี', activeGenre == 'แฟนตาซี'),
                      _buildGenreButton('สยองขวัญ', activeGenre == 'สยองขวัญ'),
                    ],
                  ),
                ),
              ),
              // ส่วนแสดงรายการเรื่อง
              ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: favoriteData.map((data) {
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
                      width: (MediaQuery.of(context).size.width - 40) / 3,
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
                                  borderRadius: BorderRadius.circular(8.0),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeGenre = text;
          fetchFavoriteData(
              text); // เรียกใช้งาน fetchFavoriteData เมื่อเลือกหมวดหมู่
        });
      },
      child: Container(
        width: 90,
        height: 45,
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
