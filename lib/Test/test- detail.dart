Future<void> updateRatingStoryAndUser(bool isFavorite) async {
  try {
    final uid_user = _user?.uid;

    // อ้างอิงไปยังเอกสารใน Firestore
    final storyRef =
        FirebaseFirestore.instance.collection("storys").doc(widget.id);

    final document = await storyRef.get();

    if (document.exists) {
      // ตรวจสอบว่าฟิล "user_favorite" มีอยู่ในเอกสารหรือไม่
      final userFavoriteExists = document.data()!.containsKey('user_favorite');

      // ตรวจสอบว่า UID ของผู้ใช้อยู่ในฟิล "user_favorite" หรือไม่
      final userFavorite =
          userFavoriteExists ? (document.data()!['user_favorite'] as List) : [];

      if (uid_user != null) {
        if (userFavorite.contains(uid_user)) {
          // UID ของผู้ใช้อยู่ใน "user_favorite", ดังนั้นลดคะแนน (-1) และลบ UID ออกจาก "user_favorite"
          await storyRef.update({
            'rating': FieldValue.increment(-1),
            'user_favorite': FieldValue.arrayRemove([uid_user])
          });

          // Update the user document in the "users" collection
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid_user)
              .update({
            'favorite': FieldValue.arrayRemove([widget.id])
          });

          // เช็คหมวดหมู่ของเรื่อง
          final categories = document.data()!['categories'];

          if (categories != null) {
            for (final category in categories) {
              final categoryField = 'score_$category';
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid_user)
                  .update({categoryField: FieldValue.increment(-1)});
            }
          }
        } else {
          // UID ของผู้ใช้ไม่อยู่ใน "user_favorite", ดังนั้นเพิ่มคะแนน (+1) และเพิ่ม UID เข้าไปใน "user_favorite"
          await storyRef.update({
            'rating': FieldValue.increment(1),
            'user_favorite': FieldValue.arrayUnion([uid_user])
          });

          // Update the user document in the "users" collection
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid_user)
              .update({
            'favorite': FieldValue.arrayUnion([widget.id])
          });

          // เช็คหมวดหมู่เรื่อง
          final categories = document.data()!['categories'];

          if (categories != null) {
            for (final category in categories) {
              final categoryField = 'score_$category';
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid_user)
                  .update({categoryField: FieldValue.increment(1)});
            }
          }
        }
      }
    }
  } catch (e) {
    print('เกิดข้อผิดพลาดในการอัปเดต rating และ favorite ใน Firestore: $e');
  }
}
