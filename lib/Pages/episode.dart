import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:apptoon/profile.dart';

class EpisodePage extends StatefulWidget {
  final String toonId;
  final String episodeId;
  final List<String> episodes;

  EpisodePage(
      {required this.toonId, required this.episodeId, required this.episodes});

  @override
  _EpisodePageState createState() => _EpisodePageState();
}

void main() {
  runApp(MaterialApp(
    home: EpisodePage(
      toonId: 'yourToonId',
      episodeId: 'yourEpisodeId',
      episodes: [],
    ),
  ));
}

class _EpisodePageState extends State<EpisodePage> {
  bool isFavorite = false; //เก็บสถานะว่าผู้ใช้ได้กดปุ่ม "Favorite" หรือไม่
  int count = 0; //เก็บจำนวนครั้งที่ผู้ใช้กดปุ่ม "Favorite" โดยค่าเริ่มต้นคือ 0
  final GlobalKey commentKey = GlobalKey();
  User? _user;

  late List<String> images = [];
  double? _ratingBarValue;
  final scrollController = AutoScrollController();
  bool _isBarsVisible = true;
  bool sliverAppBarPinned = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    _user = FirebaseAuth.instance.currentUser;
    fetchImages();
  }

  Future<void> epsisodeID_FilterNext() async {
    String episodeIdString = widget.episodeId.split(RegExp(r'[0-9]'))[0];
    int episodeIdNumber =
        int.parse(widget.episodeId.replaceAll(RegExp(r'[^0-9]'), ''));
    int nextEpisodeIdNumber = episodeIdNumber + 1;
    String nextEpisodeId = '$episodeIdString$nextEpisodeIdNumber';

    widget.episodes.sort((a, b) {
      int aEpisodeNumber = int.parse(a.split(' ')[1]);
      int bEpisodeNumber = int.parse(b.split(' ')[1]);
      return aEpisodeNumber
          .compareTo(bEpisodeNumber); // Sort in ascending order
    });

    int currentIndex = widget.episodes.indexWhere((episode) {
      int episodeNumber = int.parse(episode.split(' ')[1]);
      return episodeNumber == episodeIdNumber;
    });
    print(_user);

    if (_user == null &&
        episodeIdNumber > 0 &&
        episodeIdNumber <= 2 &&
        currentIndex < widget.episodes.length - 1) {
      print('1');
      // Navigate to the next episode
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EpisodePage(
            toonId: widget.toonId,
            episodeId: nextEpisodeId,
            episodes: widget.episodes,
          ),
        ),
      );
    } else if (_user == null &&
        episodeIdNumber > 0 &&
        episodeIdNumber > 2 &&
        currentIndex < widget.episodes.length - 1) {
      print('2');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyProfile(),
        ),
      );
    }
  }

  Future<void> epsisodeID_FilterBack() async {
    String episodeIdString = widget.episodeId.split(RegExp(r'[0-9]'))[0];
    int episodeIdNumber =
        int.parse(widget.episodeId.replaceAll(RegExp(r'[^0-9]'), ''));
    if (episodeIdNumber > 1) {
      int nextEpisodeIdNumber = episodeIdNumber - 1;
      String nextEpisodeId = '$episodeIdString$nextEpisodeIdNumber';
      // Navigate to the next episode
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EpisodePage(
            toonId: widget.toonId,
            episodeId: nextEpisodeId,
            episodes: widget.episodes,
          ),
        ),
      );
    } else {}
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

  void _onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isBarsVisible = false;
        sliverAppBarPinned = false;
      });
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isBarsVisible = true;
        sliverAppBarPinned = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isBarsVisible = !_isBarsVisible;
            sliverAppBarPinned = _isBarsVisible;
          });
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            // appbar บน
            SliverAppBar(
              floating: false,
              pinned: sliverAppBarPinned,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '${widget.episodeId}',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                background: Container(
                  color: const Color.fromARGB(255, 222, 150, 174),
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
                        color: Colors.white,
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
                              color: Color.fromARGB(255, 224, 231, 125),
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
            SliverToBoxAdapter(
              key: commentKey,
              child: Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Comment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // ทำการเพิ่มแสดง Comment ด้วย ListView, Column, หรือวิธีที่คุณต้องการ
                    // ตัวอย่างเช่น:
                    ListTile(
                      title: Text('User 1'),
                      subtitle: Text('This is a comment.'),
                    ),
                    ListTile(
                      title: Text('User 2'),
                      subtitle: Text('Another comment.'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // appbar ล่าง
      bottomNavigationBar: _isBarsVisible
          ? BottomAppBar(
              color: Color.fromARGB(255, 222, 150, 174),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              count += isFavorite ? 1 : -1;
                            });
                          },
                        ),
                        Text(
                          '$count',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            epsisodeID_FilterBack();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            epsisodeID_FilterNext();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
