// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAVSvPrhhnbO4-j8nGCAQ2p-2BEVdtmXiA',
    appId: '1:733352801116:web:251b5291b41ba5a2004799',
    messagingSenderId: '733352801116',
    projectId: 'ybigta-memegorithm',
    authDomain: 'ybigta-memegorithm.firebaseapp.com',
    storageBucket: 'ybigta-memegorithm.appspot.com',
    measurementId: 'G-FS4KHM3W6N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFuG1k0pshZKpmNzcFiX2qvZ-Ef6OXLPk',
    appId: '1:733352801116:android:187ce5478f61cdd2004799',
    messagingSenderId: '733352801116',
    projectId: 'ybigta-memegorithm',
    storageBucket: 'ybigta-memegorithm.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWIHQgzqx3YYyaMyizEbWBGrx9ZvPLCj4',
    appId: '1:733352801116:ios:1388385a6962f2a0004799',
    messagingSenderId: '733352801116',
    projectId: 'ybigta-memegorithm',
    storageBucket: 'ybigta-memegorithm.appspot.com',
    iosBundleId: 'com.example.memegorithmWeb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWIHQgzqx3YYyaMyizEbWBGrx9ZvPLCj4',
    appId: '1:733352801116:ios:8051fc2c5c91a06d004799',
    messagingSenderId: '733352801116',
    projectId: 'ybigta-memegorithm',
    storageBucket: 'ybigta-memegorithm.appspot.com',
    iosBundleId: 'com.example.memegorithmWeb.RunnerTests',
  );
}
