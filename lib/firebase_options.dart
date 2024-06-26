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
    apiKey: 'AIzaSyBclvy7CfRt1C_g20GwrXEyJmkGCqTOHt0',
    appId: '1:701933233833:web:0082e1be24ac943994abb8',
    messagingSenderId: '701933233833',
    projectId: 'sudarshan-saur',
    authDomain: 'sudarshan-saur.firebaseapp.com',
    databaseURL: 'https://sudarshan-saur-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sudarshan-saur.appspot.com',
    measurementId: 'G-2VN9DLPWE3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZXRTmo9oWpEBlYlvLqr3IgNoiaTsLa0g',
    appId: '1:701933233833:android:d7fd7bcf3711df8f94abb8',
    messagingSenderId: '701933233833',
    projectId: 'sudarshan-saur',
    databaseURL: 'https://sudarshan-saur-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sudarshan-saur.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-WlVqOyuQnX8O4Yydbg1Ch51Tz6z5Cq4',
    appId: '1:701933233833:ios:d640de5c007792b094abb8',
    messagingSenderId: '701933233833',
    projectId: 'sudarshan-saur',
    databaseURL: 'https://sudarshan-saur-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sudarshan-saur.appspot.com',
    iosBundleId: 'com.sudarshansaur.dealer.saurDealer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-WlVqOyuQnX8O4Yydbg1Ch51Tz6z5Cq4',
    appId: '1:701933233833:ios:6b2a7fb791e5a42f94abb8',
    messagingSenderId: '701933233833',
    projectId: 'sudarshan-saur',
    databaseURL: 'https://sudarshan-saur-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sudarshan-saur.appspot.com',
    iosBundleId: 'com.sudarshansaur.dealer.saurDealer.RunnerTests',
  );
}
