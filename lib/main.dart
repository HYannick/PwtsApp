import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Map<String, dynamic> options = {
    "degrees": [1, 2],
    "nbStances": [5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
    "nbIntervals": [5, 10, 15, 20, 25],
  };

  Timer timer;

  void _incrementCounter() {
    timer = Timer.periodic(Duration(seconds: 5), (_) {
      setState(() {
        _counter++;
      });
    });
  }

  void _pauseCounter() {
    timer.cancel();
  }

  void _stopCounter() {
    timer.cancel();
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Image.asset(
            'assets/wc__bg.jpg',
            fit: BoxFit.cover,
          )),
          SafeArea(
            child: Column(
              children: <Widget>[
                Text('Degré'),
                _buildLists(list: options['degrees']),
                Text('Nombre de mouvements'),
                _buildLists(list: options['nbStances']),
                Text('Intervals'),
                _buildLists(list: options['nbIntervals']),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$_counter'),
                RaisedButton(
                    child: Text('pause counter'), onPressed: _pauseCounter),
                RaisedButton(
                    child: Text('stop counter'), onPressed: _stopCounter)
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (timer != null && timer.isActive) ? null : _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Container _buildLists({List list}) {
    return Container(
        height: 50.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) =>
                Stack(children: <Widget>[
                  Positioned.fill(
                      child: SvgPicture.asset(
                    'assets/splash_brush.svg',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  )),
                  Center(
                      child: Text('${list[index]}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'CN Rocks',
                              fontWeight: FontWeight.bold)))
                ])));
  }
}
