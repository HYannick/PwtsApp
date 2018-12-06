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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static Color mainBrown = Color.fromRGBO(41, 23, 34, 1.0);
  TextStyle titleStyle =
      TextStyle(color: mainBrown, fontSize: 20.0, fontFamily: 'CN Rocks');
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

  void onSelectedItem(int index, List list) {
    print('selectedIndex');
    print(index);
    print('list');
    print(list);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/brush_trace.svg',
                  color: mainBrown,
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                ),
                OptionsList(
                  list: options['degrees'],
                  title: 'Degré',
                  onSelectedItem: onSelectedItem,
                ),
                SizedBox(
                  height: 20.0,
                ),
                OptionsList(
                  list: options['nbStances'],
                  title: 'Nombre de '
                      'mouvements',
                  onSelectedItem: onSelectedItem,
                ),
                SizedBox(
                  height: 20.0,
                ),
                OptionsList(
                  list: options['nbIntervals'],
                  title: 'Intervals',
                  onSelectedItem: onSelectedItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsList extends StatefulWidget {
  static Color mainBrown = Color.fromRGBO(41, 23, 34, 1.0);
  final String title;
  final List list;
  final Function onSelectedItem;
  OptionsList({this.title, this.list, @required this.onSelectedItem});

  @override
  OptionsListState createState() {
    return new OptionsListState();
  }
}

class OptionsListState extends State<OptionsList> {
  int _selectedItem = 0;

  TextStyle titleStyle = TextStyle(
      color: OptionsList.mainBrown, fontSize: 20.0, fontFamily: 'CN Rocks');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 70.0),
          child: Text(
            widget.title,
            style: titleStyle,
          ),
        ),
        Container(
            height: 70.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedItem = index;
                      });
                      widget.onSelectedItem(_selectedItem, widget.list);
                    },
                    child: Container(
                        width: 130.0,
                        height: 130.0,
                        margin: EdgeInsets.only(left: index == 0 ? 70.0 : 0.0),
                        child: Stack(children: <Widget>[
                          Positioned.fill(
                              child: SvgPicture.asset(
                            'assets/splash_brush.svg',
                            fit: BoxFit.cover,
                            color: _selectedItem == index
                                ? Colors.redAccent
                                : OptionsList.mainBrown,
                          )),
                          Center(
                              child: Text('${widget.list[index]}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontFamily: 'CN Rocks',
                                      fontWeight: FontWeight.bold)))
                        ])),
                  );
                })),
      ],
    );
  }
}
