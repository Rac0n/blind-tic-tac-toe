import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Blind Tic-Tac-Toe",
      home: MyGame()
    );
  }
}

_MyGameState myStat;

class MyGame extends StatefulWidget {
  MyGame({Key key}):super(key:key);
  _MyGameState createState(){
    myStat=new _MyGameState();
    
    return myStat;
  }
}

class _MyGameState extends State<MyGame>{
  restarting(){
    this.setState((){
    });
  }
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 20.0, left:30.0),
        //child: 
      )
    );
  }
}
