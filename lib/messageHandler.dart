import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
