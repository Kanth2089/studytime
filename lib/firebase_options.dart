import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD1gP5owXBLduDB_PTrr4Rth6E-niEaPV0',
    appId: '1:591794894427:web:bdaee4d6609afb7e9c317e',
    messagingSenderId: '591794894427',
    projectId: 'studytime-ada0d',
    authDomain: 'studytime-ada0d.firebaseapp.com',
    storageBucket: 'studytime-ada0d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUadDPCGkvCiYv1m_d7yODLc8MqLaIghc',
    appId: '1:591794894427:android:b104ebafdf65d1ad9c317e',
    messagingSenderId: '591794894427',
    projectId: 'studytime-ada0d',
    storageBucket: 'studytime-ada0d.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwQxlvQnlow8CmI9aYesk1IiruuGFqd4s',
    appId: '1:591794894427:ios:c412c953e5687f5b9c317e',
    messagingSenderId: '591794894427',
    projectId: 'studytime-ada0d',
    storageBucket: 'studytime-ada0d.firebasestorage.app',
    iosBundleId: 'com.example.studytime',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwQxlvQnlow8CmI9aYesk1IiruuGFqd4s',
    appId: '1:591794894427:ios:c412c953e5687f5b9c317e',
    messagingSenderId: '591794894427',
    projectId: 'studytime-ada0d',
    storageBucket: 'studytime-ada0d.firebasestorage.app',
    iosBundleId: 'com.example.studytime',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD1gP5owXBLduDB_PTrr4Rth6E-niEaPV0',
    appId: '1:591794894427:web:6fe409bb4c9928fb9c317e',
    messagingSenderId: '591794894427',
    projectId: 'studytime-ada0d',
    authDomain: 'studytime-ada0d.firebaseapp.com',
    storageBucket: 'studytime-ada0d.firebasestorage.app',
  );
}
