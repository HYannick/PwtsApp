import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Image.asset(
            'images/wc__bg.jpg',
            fit: BoxFit.cover,
          )),
          Column(
            children: <Widget>[
              Text('Degré'),
              Container(
                height: 50.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/splash_brush.png'),
                                fit: BoxFit.cover)),
                        child: Center(
                            child: Text('1',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)))),
                    Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/splash_brush.png'),
                                fit: BoxFit.cover)),
                        child: Center(
                            child: Text(
                          '2',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )))
                  ],
                ),
              ),
              Text('Nombre de mouvements'),
              Text('Intervals'),
            ],
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
