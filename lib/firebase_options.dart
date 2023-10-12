import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return getAndroidFirebaseOptions(); // Use the Android Firebase options.
  }

  static FirebaseOptions getAndroidFirebaseOptions() {
    return FirebaseOptions(
      apiKey: 'AIzaSyD8_tWNt54gaFWqqGqhHalJUDnYaqohm7o',
      appId: '1:828435202153:android:be26f871a1f1dc69f5e2f8',
      messagingSenderId: '828435202153',
      projectId: 'test-c6db1',
      databaseURL: 'https://test-c6db1-default-rtdb.firebaseio.com',
      storageBucket: 'test-c6db1.appspot.com',
    );
  }
}
