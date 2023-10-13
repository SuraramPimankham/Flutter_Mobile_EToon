import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String id;
  final String author;
  final String title;
  final String imageUrl;

  // Constructor สำหรับรับข้อมูลจากหน้าก่อนหน้า
  DetailPage(
      {required this.id,
      required this.author,
      required this.title,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดเรื่อง'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ชื่อเรื่อง: $title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'ผู้เขียน: $author',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'ID: $id',
              style: TextStyle(fontSize: 18),
            ),
            Image.network(
              imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            // ส่วนนี้คือส่วนอื่น ๆ ที่คุณต้องการแสดงในหน้ารายละเอียด
            // ...
          ],
        ),
      ),
    );
  }
}
