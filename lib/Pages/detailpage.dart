import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptoon/Pages/episode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptoon/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  User? _user; // ทำให้ _user เป็น nullable
  late List<String> episodes = [];
  late List<String> episodeIds = [];
  String selectedEpisodeId = '';

  @override
  void initState() {
    super.initState();
    // ตรวจสอบสถานะการล็อกอินของผู้ใช้
    _user = FirebaseAuth.instance.currentUser;
    fetchEpisodes();
  }

  Future<void> checkUserLoginStatus(bool isLocked, String episodeId) async {
    // ตรวจสอบว่าผู้ใช้ล็อกอินอยู่หรือไม่
    bool isLoggedIn = _user != null;

    if (isLoggedIn) {
      // มีการเข้าสู่ระบบ ให้ไปยังหน้า EpisodePage
      goToEpisodePage(episodeId);
    } else if (!isLoggedIn && !isLocked) {
      goToEpisodePage(episodeId);
    } else {
      // ถ้าตอนนี้มีการล็อค
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
      backgroundColor: Colors.black,
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
                color: Color.fromARGB(255, 235, 177, 196),
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
                color: Colors.black,
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
                      color: Color.fromARGB(255, 235, 177, 196),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                          onTap: () async {
                            if (_user == null && !isLocked) {
                              // ถ้าผู้ใช้ไม่ได้เข้าสู่ระบบ และตอนไม่ได้ lock ให้ไปยังหน้า
                              String episode_id = episodeIds[entry.key];
                              setState(() {
                                selectedEpisodeId = episode_id;
                              });
                              goToEpisodePage(episode_id);
                            } else if (_user == null) {
                              // ถ้าผู้ใช้ไม่ได้เข้าสู่ระบบ ให้ไปยังหน้า MyProfile
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyProfile(),
                                ),
                              );
                            } else {
                              // ถ้าผู้ใช้เข้าสู่ระบบ
                              String episode_id = episodeIds[entry.key];
                              setState(() {
                                selectedEpisodeId = episode_id;
                              });

                              if (isLocked) {
                                // ดึงข้อมูล coin จาก Firestore
                                DocumentSnapshot userDoc = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(_user
                                        ?.uid) // ใช้ null-aware operator ที่นี่
                                    .get();

                                // ตรวจสอบว่ามีเหรียญพอหรือไม่
                                int coins = userDoc['coin'] ?? 0;

                                if (coins >= 15) {
                                  // แสดงตัวเลือกการซื้อ
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('EP ที่ติด Icon Lock'),
                                        content:
                                            Text("ต้องการซื้อ EP นี้หรือไม่?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('ยกเลิก'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('ซื้อ'),
                                            onPressed: () async {
                                              // ลบเหรียญ 15 จาก Firestore
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(_user
                                                      ?.uid) // ใช้ null-aware operator ที่นี่
                                                  .update({
                                                'coin':
                                                    FieldValue.increment(-15),
                                              });

                                              // ทำการนำทางไปยังหน้า EpisodePage
                                              Navigator.of(context).pop();
                                              goToEpisodePage(episode_id);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // แจ้งเตือนถ้าเงินไม่พอ
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('เงินไม่พอ'),
                                        content: Text(
                                            "คุณไม่มีเหรียญเพียงพอที่จะซื้อ EP นี้"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('ตกลง'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                // EP ไม่ติด Icon Lock ให้ไปยังหน้า EpisodePage โดยตรง
                                goToEpisodePage(episode_id);
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection(widget.id)
                                    .doc(episodeIds[entry.key])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // แสดง CircularProgressIndicator ในระหว่างโหลดข้อมูล
                                    return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 8,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      const Color.fromARGB(
                                                          255, 255, 255, 255)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (snapshot.hasError) {
                                      // ถ้าเกิดข้อผิดพลาดในการโหลดข้อมูล
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // ถ้าโหลดข้อมูลสำเร็จ
                                      List<dynamic> imagesDynamic =
                                          snapshot.data?['images'] ?? [];
                                      List<String> images = imagesDynamic
                                          .map((e) => e.toString())
                                          .cast<String>()
                                          .toList();
                                      String imageUrl = images.isNotEmpty
                                          ? images[0]
                                          : ''; // ดึง URL ภาพแรกจาก images

                                      if (imageUrl.isNotEmpty) {
                                        // ถ้ามี URL ให้แสดงรูปภาพ
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: SizedBox(
                                              width: 70,
                                              height: 70,
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        // ถ้าไม่มี URL ให้ใช้ Container ว่าง
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: SizedBox(
                                              width: 70,
                                              height: 70,
                                              child: Container(),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Ep ${episodes[entry.key].split(' ')[1]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.favorite, color: Colors.white),
                                      Text('data'),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              if (isLocked)
                                Text('15', style: TextStyle(fontSize: 16)),
                              if (isLocked)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.monetization_on_outlined,
                                      color: Colors.black),
                                ),
                            ],
                          )),
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
