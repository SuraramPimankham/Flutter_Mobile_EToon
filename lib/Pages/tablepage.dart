import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTablePage extends StatefulWidget {
  const MyTablePage();

  @override
  _MyTablePageState createState() => _MyTablePageState();
}

class _MyTablePageState extends State<MyTablePage> {
  String activeButton = 'จ'; // ปุ่ม "จ" เป็นปุ่ม active เริ่มต้น
  Map<String, String> dayMap = {
    'จ': 'monday',
    'อ': 'tuesday',
    'พ': 'wednesday',
    'พฤ': 'thursday',
    'ศ': 'friday',
    'ส': 'saturday',
    'อา': 'sunday',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Table'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(
                            'จ',
                            activeButton ==
                                'จ'), // ปรับสีของปุ่ม "จ" ตาม activeButton
                        _buildButton('อ', activeButton == 'อ'),
                        _buildButton('พ', activeButton == 'พ'),
                        _buildButton('พฤ', activeButton == 'พฤ'),
                        _buildButton('ศ', activeButton == 'ศ'),
                        _buildButton('ส', activeButton == 'ส'),
                        _buildButton('อา', activeButton == 'อา'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                width: 400,
                height: 400, // ขนาดสูงของ GridView
                color: Colors.white,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // จำนวน columns ใน GridView
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // สร้าง Card ใน GridView
                    return Card(
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Item $index',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 9,
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
          activeButton = text; // เปลี่ยนปุ่ม active เมื่อปุ่มถูกแตะ
          String dayKey = dayMap[text] ??
              ''; // ดึงค่าจาก dayMap ที่เกี่ยวข้องกับปุ่มที่ถูกกด
          if (dayKey.isNotEmpty) {
            // ดึงข้อมูลจาก Firebase โดยใช้ dayKey
            // จากนั้นนำข้อมูลมาแสดงใน GridView โดยลบ Card เก่าทิ้ง
            // เรียกฟังก์ชันเพื่อดึงข้อมูลจาก Firebase โดยใช้ dayKey
            // จากนั้นนำข้อมูลมาแสดงใน GridView โดยลบ Card เก่าทิ้ง
          }
        });
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isActive
              ? Colors.blue
              : Colors.lightBlue, // เปลี่ยนสีของปุ่มตาม isActive
          borderRadius: BorderRadius.circular(10), // ทำให้มีรูปร่างเป็นวงกลม
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white, // สีของตัวหนังสือ
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
