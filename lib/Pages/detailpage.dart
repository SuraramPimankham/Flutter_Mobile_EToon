import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;

  DetailPage({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<String> episodes = [];

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    try {
      CollectionReference episodesCollection =
          FirebaseFirestore.instance.collection(widget.id);

      QuerySnapshot episodesSnapshot = await episodesCollection.get();

      if (episodesSnapshot.docs.isNotEmpty) {
        setState(() {
          episodes.clear();
        });

        // Add episode values to the list
        episodesSnapshot.docs.forEach((doc) {
          String episode = doc['ep']; // Assuming the field name is 'ep'
          episodes.add('EP $episode');
        });

        // Sort episodes from high to low
        episodes.sort((a, b) {
          int aEpisodeNumber =
              int.parse(a.split(' ')[1]); // Extract episode number
          int bEpisodeNumber = int.parse(b.split(' ')[1]);
          return bEpisodeNumber
              .compareTo(aEpisodeNumber); // Sort from high to low
        });
      }
    } catch (e) {
      print('Error fetching episodes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดเรื่อง'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.grey[300],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.imageUrl,
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Title: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Author: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.author,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.grey[300],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: episodes
                      .map((episode) => Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.grey[200],
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    '$episode',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
