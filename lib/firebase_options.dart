// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
/// 
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
    apiKey: 'AIzaSyBxheguRLFwcfp9ImHcqGI1curNd_X3Lz4',
    appId: '1:623418869958:web:8cc54e0134971c1dd86fc7',
    messagingSenderId: '623418869958',
    projectId: 'bookingroom-keld',
    authDomain: 'bookingroom-keld.firebaseapp.com',
    storageBucket: 'bookingroom-keld.firebasestorage.app',
    measurementId: 'G-FTQVPW25PR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7fMlPIbvKnVmj2Y7sBEeorhTK9lM5IHA',
    appId: '1:623418869958:android:a1dcc8ec92993ed0d86fc7',
    messagingSenderId: '623418869958',
    projectId: 'bookingroom-keld',
    storageBucket: 'bookingroom-keld.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClS6FjgKmtCfo9v7sp3KMxdpB_M-QkWZg',
    appId: '1:623418869958:ios:841d0d87f81f8598d86fc7',
    messagingSenderId: '623418869958',
    projectId: 'bookingroom-keld',
    storageBucket: 'bookingroom-keld.firebasestorage.app',
    iosBundleId: 'com.example.bookingroom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClS6FjgKmtCfo9v7sp3KMxdpB_M-QkWZg',
    appId: '1:623418869958:ios:841d0d87f81f8598d86fc7',
    messagingSenderId: '623418869958',
    projectId: 'bookingroom-keld',
    storageBucket: 'bookingroom-keld.firebasestorage.app',
    iosBundleId: 'com.example.bookingroom',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxheguRLFwcfp9ImHcqGI1curNd_X3Lz4',
    appId: '1:623418869958:web:faef52a16340b5dad86fc7',
    messagingSenderId: '623418869958',
    projectId: 'bookingroom-keld',
    authDomain: 'bookingroom-keld.firebaseapp.com',
    storageBucket: 'bookingroom-keld.firebasestorage.app',
    measurementId: 'G-B5ZXSNW9G0',
  );
}