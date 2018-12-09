import 'package:flutter/material.dart';
import 'package:pwts_app/abstracts.dart';
import 'package:pwts_app/components/splashscreen.dart';
import 'package:pwts_app/views/stance-view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PWTSRA',
        home: Scaffold(
          backgroundColor: mainLight,
          body: Stack(
            children: <Widget>[
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    splashScreenBg,
                    height: 200.0,
                    alignment: Alignment.bottomCenter,
                  )),
              SplashScreen(
                  seconds: 5,
                  navigateAfterSeconds: StanceTraining(),
                  title: Text(
                    '詠春',
                    style: TextStyle(
                        color: mainBrown,
                        fontWeight: FontWeight.bold,
                        fontSize: 50.0,
                        fontFamily: familyTertiary),
                  ),
                  backgroundColor: Colors.transparent,
                  styleTextUnderTheLoader: TextStyle(fontFamily: familyMain),
                  loaderColor: mainRed),
            ],
          ),
        ));
  }
}
