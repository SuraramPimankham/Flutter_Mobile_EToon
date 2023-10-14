import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EpisodePage extends StatefulWidget {
  final String toonId;
  final String episodeId;

  EpisodePage({required this.toonId, required this.episodeId});

  @override
  _EpisodePageState createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  late List<String> images = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      DocumentSnapshot episodeSnapshot = await FirebaseFirestore.instance
          .collection(widget.toonId)
          .doc(widget.episodeId)
          .get();

      if (episodeSnapshot.exists) {
        setState(() {
          images = List.from(episodeSnapshot['images']);
        });
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.episodeId}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(0),
                  child: Image.network(images[index]),
                );
              },
              childCount: images.length,
            ),
          ),
        ],
      ),
    );
  }
}
