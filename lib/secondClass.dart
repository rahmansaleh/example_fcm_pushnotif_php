import 'package:flutter/material.dart';

class SecondClassLess extends StatelessWidget {

  String payload;

  SecondClassLess({Key key, this.payload}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return SecondClassFul(
      payload: payload,
    );
  }
}

class SecondClassFul extends StatefulWidget {

  String payload;

  SecondClassFul({this.payload});

  @override
  _SecondClassFulState createState() => _SecondClassFulState(
    payload: payload
  );
}

class _SecondClassFulState extends State<SecondClassFul> {

  String payload;

  _SecondClassFulState({this.payload});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: new Center(
        child: new Text(
          'Payload : $payload'
        ),
      ),
      
    );
  }
}