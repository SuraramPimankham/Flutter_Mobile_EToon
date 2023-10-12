import 'package:flutter/material.dart';

class MyTablePage extends StatelessWidget {
  const MyTablePage();

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
        ],
      ),
    );
  }
}
