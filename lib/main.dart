import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'test.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Firebaseの初期化
    await Firebase.initializeApp();

    // Firebaseの初期化（セカンダリ）
    String apiKey;
    String appId;
    if( Platform.isAndroid ){
      apiKey = 'AIzaSyCPu9WzfXFq2Et87U8mQhLitUNqbqla8jU';
      appId = '1:147899670715:android:57dd2dd6b8ad7db3a4099e';
    } else {
      apiKey = 'AIzaSyATDhdkQL1JKWBzD_c03I16SqXJqj0Za8w';
      appId = '1:147899670715:ios:741fb2f409944345a4099e';
    }
    await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: '147899670715',
          projectId: 'flutter-firebase-test-2887e',
        )
    );

    // Firebase Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(const MyApp());
  }, (error, stack) {
    // Firebase Crashlytics
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State createState() => MyHomePageState();
}

class MyHomePageState extends State {
  double contentWidth  = 0.0;
  double contentHeight = 0.0;

  var console = <Widget>[];
  void addConsole( Widget widget ){
    setState(() {
      console.add( widget );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      test1( this );
//      test2( this );
//      test3( this );
//      test4( this );
    });
  }

  @override
  Widget build(BuildContext context) {
    contentWidth  = MediaQuery.of( context ).size.width;
    contentHeight = MediaQuery.of( context ).size.height - MediaQuery.of( context ).padding.top - MediaQuery.of( context ).padding.bottom;

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 0
        ),
        body: SingleChildScrollView(
            child: Column(
                children: console
            )
        )
    );
  }
}
