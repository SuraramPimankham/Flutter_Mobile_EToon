import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:apptoon/Pages/detailpage.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCategoryButtons(),
            _buildRecommendedStories(),
            _buildAction(),
            // _buildRomantic(),
            // _buildComedy(),
            // _buildFantasy(),
            // _buildHorror(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      width: 400,
      color: Colors.white,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'หมวดหมู่',
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('ต่อสู้');
                  },
                  child: Text('แอ็กชัน'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('โรแมนติก');
                  },
                  child: Text('โรแมนติก'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('ตลก');
                  },
                  child: Text('ตลก'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('แฟนตาซี');
                  },
                  child: Text('แฟนตาซี'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('สยองขวัญ');
                  },
                  child: Text('สยองขวัญ'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // แนะนำ
  Widget _buildRecommendedStories() {
    return Container(
      width: 400,
      height: 338,
      color: Color.fromARGB(255, 241, 129, 166),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'แนะนำ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
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
                    child: Text('ไม่พบข้อมูลในคอลเลกชัน "storys"'),
                  );
                }

                // Return the ListView.builder here
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    final data = document.data() as Map<String, dynamic>;

                    final id = data['id'];
                    final author = data['author'];
                    final title = data['title'];
                    final imageUrl = data['imageUrl'];
                    final description = data['description'];

                    // Define the desired size for the image container and card
                    final itemWidth = 150.0;
                    final itemHeight = 250.0;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              id: id,
                              author: author,
                              title: title,
                              imageUrl: imageUrl,
                              description: description,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: itemWidth,
                        height: itemHeight,
                        // margin: EdgeInsets.all(10),
                        child: Card(
                          elevation: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8.0), // ปรับขนาดมุมของการ์ด
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit
                                  .cover, // ให้รูปภาพปรับขนาดให้พอดีกับการ์ด
                            ),
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

  // แอ็กชัน
  Widget _buildAction() {
    return Container(
      width: 400,
      height: 338,
      color: Color.fromARGB(255, 241, 129, 166),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'แอ็กชัน',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {
                  // ตรงนี้คุณสามารถระบุการดำเนินการเมื่อปุ่ม "More" ถูกคลิก
                  print('More button clicked');
                },
                child: Text(
                  'More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 230,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('storys')
                  .where('categories', arrayContains: 'action')
                  .snapshots(),
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
                    child: Text('ไม่พบข้อมูลในคอลเลกชัน "storys"'),
                  );
                }

                // Return the ListView.builder here
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    final data = document.data() as Map<String, dynamic>;

                    final id = data['id'];
                    final author = data['author'];
                    final title = data['title'];
                    final imageUrl = data['imageUrl'];
                    final description = data['description'];

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
                              id: id,
                              author: author,
                              title: title,
                              imageUrl: imageUrl,
                              description: description,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 120,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          imageUrl,
                                          width: 130,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double
                                            .infinity, // ทำให้ Text ขยายตามขนาดของ Card
                                        child: Text(
                                          '$title',
                                          overflow: TextOverflow
                                              .ellipsis, // ถ้ายาวเกินจะทำการตัดข้อความ
                                          maxLines:
                                              1, // จำกัดให้แสดงเพียง 1 บรรทัด
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye),
                                        Text("120"),
                                        Icon(Icons.favorite),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
}
