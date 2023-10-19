import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptoon/Pages/episode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptoon/profile.dart'; // เพิ่ม import

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

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

class _DetailPageState extends State<DetailPage> {
  late List<String> episodes = [];
  late List<String> episodeIds = [];
  String selectedEpisodeId = '';

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> checkUserLoginStatus(bool isLocked, String episodeId) async {
    bool isLoggedIn = await widget.isUserLoggedIn();

    if (isLoggedIn) {
      // มีการเข้าสู่ระบบ ให้ไปยังหน้า EpisodePage
      goToEpisodePage(episodeId);
    } else {
      // ไม่มีการเข้าสู่ระบบ ให้ไปยังหน้า MyProfile
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyProfile(),
        ),
      );
    }
  }

  void goToEpisodePage(String episodeId) {
    // นำทางไปยังหน้า EpisodePage โดยใช้ episodeId
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EpisodePage(
          toonId: widget.id,
          episodeId: episodeId,
        ),
      ),
    );
  }

  Future<void> fetchEpisodes() async {
    try {
      CollectionReference episodesCollection =
          FirebaseFirestore.instance.collection(widget.id);

      QuerySnapshot episodesSnapshot = await episodesCollection.get();

      if (episodesSnapshot.docs.isNotEmpty) {
        setState(() {
          episodes.clear();
          episodeIds.clear();
        });

        episodesSnapshot.docs.forEach((doc) {
          String episode_id = doc.id;
          String episode = doc['ep'];
          episodes.add('EP $episode');
          episodeIds.add(episode_id);
        });

        episodes.sort((a, b) {
          int aEpisodeNumber = int.parse(a.split(' ')[1]);
          int bEpisodeNumber = int.parse(b.split(' ')[1]);
          return bEpisodeNumber.compareTo(aEpisodeNumber);
        });
        episodeIds.sort((a, b) {
          int aEpisodeNumber = int.tryParse(a.split('EP ')[1]) ?? 0;
          int bEpisodeNumber = int.tryParse(b.split('EP ')[1]) ?? 0;
          return bEpisodeNumber.compareTo(aEpisodeNumber);
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
                  mainAxisSize: MainAxisSize.max,
                  children: episodes.asMap().entries.map((entry) {
                    int episodeNumber =
                        int.tryParse(episodes[entry.key].split(' ')[1]) ?? 0;

                    // เช็คว่า EP มีการติด Icon Lock หรือไม่
                    bool isLocked = episodeNumber >= 4;

                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Colors.grey[200],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          String episode_id = episodeIds[entry.key];
                          setState(() {
                            selectedEpisodeId = episode_id;
                          });

                          if (isLocked) {
                            // เช็คว่ามีการเข้าสู่ระบบหรือไม่
                            checkUserLoginStatus(isLocked, episode_id);
                          } else {
                            // EP ไม่ติด Icon Lock ให้ไปยังหน้า EpisodePage โดยตรง
                            goToEpisodePage(episode_id);
                          }
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  if (isLocked)
                                    Icon(Icons.lock), // เพิ่ม icon ที่นี่
                                  Text(
                                    '${episodes[entry.key]} - ${episodeIds[entry.key]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
