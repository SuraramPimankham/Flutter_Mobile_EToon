import 'package:flutter/material.dart';

class MyCartoonsPage extends StatefulWidget {
  const MyCartoonsPage({Key? key}) : super(key: key);

  @override
  State<MyCartoonsPage> createState() => _MyCartoonsPageState();
}

class _MyCartoonsPageState extends State<MyCartoonsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyCartoonsPage'),
      ),
       body: Center(
        child:
            Text('เพิ่มเพื่อนที่นี่1'), // สามารถแทนด้วยเนื้อหาที่คุณต้องการแสดง
      ),
    );
  }
}