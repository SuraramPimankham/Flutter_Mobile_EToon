import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTablePage extends StatefulWidget {
  const MyTablePage();

  @override
  _MyTablePageState createState() => _MyTablePageState();
}

class _MyTablePageState extends State<MyTablePage> {
  String activeButton = 'จ';
  Map<String, String> dayMap = {
    'จ': 'monday',
    'อ': 'tuesday',
    'พ': 'wednesday',
    'พฤ': 'thursday',
    'ศ': 'friday',
    'ส': 'saturday',
    'อา': 'sunday',
  };

  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> storyData = [];

  @override
  void initState() {
    super.initState();
    fetchStoryData('จ'); // Fetch data initially for 'จ'
  }

  // Function to fetch data from Firestore
  Future<void> fetchStoryData(String day) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('storys')
          .where('day', isEqualTo: day)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Clear the existing data
        setState(() {
          storyData.clear();
        });

        // Add new data
        querySnapshot.docs.forEach((doc) {
          storyData.add({
            'id': doc.id,
            'title': doc['title'],
            'imageUrl': doc['imageUrl'],
          });
        });
      } else {
        // No data found
        setState(() {
          storyData.clear();
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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
                        _buildButton('จ', activeButton == 'จ'),
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
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      constraints: BoxConstraints(minHeight: 600),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: storyData.map((data) {
                          return Container(
                            width: (MediaQuery.of(context).size.width - 40) / 3,
                            height: 200,
                            child: Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        data['imageUrl'],
                                        fit: BoxFit.cover,
                                        height: 140,
                                        width: double.infinity,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    FittedBox(
                                      fit: BoxFit
                                          .scaleDown, // ปรับขนาดของข้อความให้เล็กลงถ้าข้อความยาวเกิน Card
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
          String dayKey = dayMap[text] ?? '';
          if (dayKey.isNotEmpty) {
            fetchStoryData(dayKey); // Fetch data for the selected day
          }
        });
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.lightBlue,
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
