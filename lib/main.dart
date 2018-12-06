import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pwts_app/components/options-list.dart';
import 'package:pwts_app/resources/stances.dart';

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
  Map<String, dynamic> selectedStance;
  TextStyle titleStyle =
      TextStyle(color: mainBrown, fontSize: 20.0, fontFamily: 'CN Rocks');
  Map<String, dynamic> options = {
    "degrees": [1, 2],
    "nbStances": [5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
    "intervals": [1, 2, 3, 4, 5, 10],
  };

  Map<String, dynamic> selectedOptions = {
    "degree": 1,
    "nbStances": 5,
    "intervals": 1,
  };

  Timer timer;

  void _initStances() {
    final stances = Stances();
    final filteredStances =
        stances.getStancesByDegree(degree: selectedOptions['degree']);

    timer =
        Timer.periodic(Duration(seconds: selectedOptions['intervals']), (_) {
      if (_counter < selectedOptions['nbStances']) {
        setState(() {
          selectedStance = stances.getRandomStance(stances: filteredStances);
          _counter++;
        });
      } else {
        _stopCounter();
      }
    });
  }

  void _stopCounter() {
    timer.cancel();
    setState(() {
      _counter = 0;
    });
  }

  void onSelectedItem(int index, List list, String field) {
    selectedOptions[field] = list[index];
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
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: new Text(
                  "詠春",
                  style: TextStyle(color: Colors.white, fontSize: 35.0),
                ),
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  width: 50.0,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(-60.0, -30.0)
                      ..scale(1.7),
                    child: SvgPicture.asset(
                      'assets/brush_trace.svg',
                      width: 50.0,
                      height: 80.0,
                      color: mainBrown,
                    ),
                  ),
                ),
                elevation: 0.0,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 20.0,
                  ),
                  OptionsList(
                    list: options['degrees'],
                    title: 'Degré',
                    field: 'degree',
                    onSelectedItem: onSelectedItem,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  OptionsList(
                    list: options['nbStances'],
                    title: 'Nombre de mouvements',
                    field: 'nbStances',
                    onSelectedItem: onSelectedItem,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  OptionsList(
                    list: options['intervals'],
                    title: 'Temps',
                    field: 'intervals',
                    onSelectedItem: onSelectedItem,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  GestureDetector(
                    onTap: _initStances,
                    child: Center(
                      child: SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: SvgPicture.asset(
                              'assets/go_bg'
                                  '.svg',
                              fit: BoxFit.cover,
                              color: mainBrown,
                            )),
                            Center(
                              child: Text(
                                'GO',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 120.0,
                                    fontFamily: 'CN takeway'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: RawMaterialButton(
          child: Container(
            width: 80.0,
            height: 80.0,
            child: SvgPicture.asset(
              'assets/splash_brush.svg',
              fit: BoxFit.cover,
              color: Colors.redAccent,
            ),
          ),
          onPressed: () {
            print('other page stances');
          }),
    );
  }
}
