import 'dart:async';
import 'dart:io';
import 'package:example_fcm_pushnotif_php/secondClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageHandlerLess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageHandlerState(
      
    );
  }
}

class MessageHandlerState extends StatefulWidget {
  @override
  _MessageHandlerStateState createState() => _MessageHandlerStateState();
}

class _MessageHandlerStateState extends State<MessageHandlerState> {

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  

  Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload
  ) async {

    showDialog(
      context: context,
      builder: (context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: <Widget>[

          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('OK'),
            onPressed: () async {
              Navigator.of(context).pop();
              await Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => new SecondClassLess()
                ),
              );
            },
          )
        ],
      ) 
    );
  }

  Future onSelectedNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification Payload : '+payload);
    }

    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => new SecondClassLess();
      )
    );
  }
  _saveDeviceToken() async {

    String uid = 'rhmn96';
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      
      var tokens = _db
      .collection('users')
      .document(uid)
      .collection('tokens')
      .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'created_at': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _saveDeviceToken();

    

    if ( Platform.isIOS) {

      iosSubscription = _fcm.onIosSettingsRegistered.listen((data){

        }
      );

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');

        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: ListTile(
              title: Text(
                message['notification']['title']
              ),
              subtitle: Text(
                message['notification']['body']
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          )
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      }
    );

    var initializationSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: new Center(
        child: new FlatButton(
          child: new Text(
            'Show Dialog',
          ),
          onPressed: (){
            
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: ListTile(
                  title: Text(
                    'title'
                  ),
                  subtitle: Text(
                    'body'
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              )
            );
          },
        )
      ),
      
    );
  }
}
