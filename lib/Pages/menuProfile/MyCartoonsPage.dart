
import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child:
            Text('หนังสือ'), // สามารถแทนด้วยเนื้อหาที่คุณต้องการแสดง
      ),
    );
  }
}
