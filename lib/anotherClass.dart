import 'package:flutter/material.dart';

class AnotherClass extends StatefulWidget {

  String payload;

  AnotherClass({this.payload});
  @override
  _AnotherClassState createState() => _AnotherClassState(
    payload: payload
  );
}

class _AnotherClassState extends State<AnotherClass> {

  String payload;

  _AnotherClassState({this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back
          ),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
        title: new Text(
          payload != null ? payload : 'Default title'
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help,
            ),
            onPressed: null,
          )
        ],
      ),
      
    );
  }
}