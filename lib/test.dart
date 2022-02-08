import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

import 'main.dart';

class MyText extends Container {
  MyText( MyHomePageState state, String text, {Key? key} ) : super(key: key,
      width: state.contentWidth,
      alignment: Alignment.topLeft,
      child: Text( text )
  );
}
class MyTextColor extends Container {
  MyTextColor( MyHomePageState state, String text, {Key? key} ) : super(key: key,
      width: state.contentWidth,
      alignment: Alignment.topLeft,
      child: Text(
          text,
          style: const TextStyle(
              color: Color( 0xFF0000FF )
          )
      )
  );
}

void test1( MyHomePageState state ) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference collection = firestore.collection('2022');

  QuerySnapshot query = await collection.get();
  List<QueryDocumentSnapshot> docs = query.docs;

  for (QueryDocumentSnapshot document in docs) {
    state.addConsole(MyTextColor(state, '${document.id}月'));
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Iterable<String> keys = data.keys;
    for (String key in keys) {
      dynamic value = data[key];
      state.addConsole(MyText(state, '$key日　$value'));
    }
  }
}

void test2( MyHomePageState state ) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference collection = firestore.collection('2022');

  for (int i = 1; i <= 12; i++) {
    state.addConsole(MyTextColor(state, '$i月'));
    DocumentSnapshot document = await collection.doc('$i').get();

    if (document.exists) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      Iterable<String> keys = data.keys;
      for (String key in keys) {
        dynamic value = data[key];
        state.addConsole(MyText(state, '$key日　$value'));
      }
    }
  }
}

void test3( MyHomePageState state ) async {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: Duration(seconds: 10),
    minimumFetchInterval: Duration(hours: 1),
  ));

  state.addConsole(MyTextColor(state, 'fetchAndActivate'));
  bool updated = await remoteConfig.fetchAndActivate();
  state.addConsole(MyText(state, '$updated'));

  state.addConsole(MyTextColor(state, 'getBool'));
  bool boolValue = remoteConfig.getBool( 'hoge' );
  state.addConsole(MyText(state, '$boolValue'));

  state.addConsole(MyTextColor(state, 'getInt'));
  int intValue = remoteConfig.getInt( 'fuga' );
  state.addConsole(MyText(state, '$intValue'));

  state.addConsole(MyTextColor(state, 'getString'));
  String stringValue = remoteConfig.getString( 'piyo' );
  state.addConsole(MyText(state, stringValue));
}

void test4( MyHomePageState state ) async {
  FirebaseApp secondaryApp = Firebase.app('SecondaryApp');

  // Cloud Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: secondaryApp);
  CollectionReference collection = firestore.collection('2022');
  for (int i = 1; i <= 12; i++) {
    state.addConsole(MyTextColor(state, '$i月'));
    DocumentSnapshot document = await collection.doc('$i').get();
    if (document.exists) {
      try {
        dynamic value = document.get('start');
        if( value == 'Sun' ){ state.addConsole(MyText(state, 'start: 日')); }
        else if( value == 'Mon' ){ state.addConsole(MyText(state, 'start: 月')); }
        else if( value == 'Tue' ){ state.addConsole(MyText(state, 'start: 火')); }
        else if( value == 'Wed' ){ state.addConsole(MyText(state, 'start: 水')); }
        else if( value == 'Thu' ){ state.addConsole(MyText(state, 'start: 木')); }
        else if( value == 'Fri' ){ state.addConsole(MyText(state, 'start: 金')); }
        else if( value == 'Sat' ){ state.addConsole(MyText(state, 'start: 土')); }
        else { state.addConsole(MyText(state, 'start: 不定値')); }
      } on StateError {
        state.addConsole(MyText(state, 'start: 未登録'));
      }
      try {
        dynamic value = document.get('days');
        state.addConsole(MyText(state, 'days: $value日'));
      } on StateError {
        state.addConsole(MyText(state, 'days: 未登録'));
      }
    }
  }

  // Firebase Remote Config
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instanceFor(app: secondaryApp);
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: Duration(seconds: 10),
    minimumFetchInterval: Duration(hours: 1),
  ));
  state.addConsole(MyTextColor(state, 'fetchAndActivate'));
  bool updated = await remoteConfig.fetchAndActivate();
  state.addConsole(MyText(state, '$updated'));
  state.addConsole(MyTextColor(state, 'getBool'));
  bool boolValue = remoteConfig.getBool( 'hogera' );
  state.addConsole(MyText(state, '$boolValue'));

  // Firebase Remote Config（プライマリ）
  test3( state );
}
