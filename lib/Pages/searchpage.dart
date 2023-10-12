import 'package:flutter/material.dart';

class MySearchPage extends StatelessWidget {
  const MySearchPage();

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