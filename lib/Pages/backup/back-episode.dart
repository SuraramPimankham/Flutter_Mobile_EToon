import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class EpisodePage extends StatefulWidget {
  final String toonId;
  final String episodeId;

  EpisodePage({required this.toonId, required this.episodeId});

  @override
  _EpisodePageState createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  late List<String> images = [];
  double? _ratingBarValue;
  final scrollController = AutoScrollController();

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
        controller: scrollController,
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
                  child: AutoScrollTag(
                    key: ValueKey(index),
                    controller: scrollController,
                    index: index,
                    child: Image.network(images[index]),
                  ),
                );
              },
              childCount: images.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                AutoScrollTag(
                  key: ValueKey('top'),
                  controller: scrollController,
                  index: 0,
                  child: GestureDetector(
                    onTap: () {
                      scrollController.scrollToIndex(
                        0,
                        preferPosition: AutoScrollPosition.begin,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.white, // Set your desired color here
                      child: Center(
                        child: Text(
                          'ไปที่ด้านบนสุด',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Score',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          onRatingUpdate: (newValue) =>
                              setState(() => _ratingBarValue = newValue),
                          itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                          ),
                          direction: Axis.horizontal,
                          initialRating: _ratingBarValue ?? 2,
                          unratedColor: Color(0x4D151313),
                          itemCount: 5,
                          itemSize: 40,
                          glowColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
