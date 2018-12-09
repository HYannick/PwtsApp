import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pwts_app/components/options-list.dart';
import 'package:pwts_app/models/stance.dart';
import 'package:pwts_app/resources/stances.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ButtonState { countdown, playing, stopped }

const cubicEase = const Cubic(0.8, 0, 0.2, 1);

class StanceTraining extends StatefulWidget {
  StanceTraining({Key key}) : super(key: key);

  @override
  _StanceTrainingState createState() => _StanceTrainingState();
}

class _StanceTrainingState extends State<StanceTraining>
    with SingleTickerProviderStateMixin {
  static Color mainBrown = Color.fromRGBO(41, 23, 34, 1.0);
  Stance selectedStance;
  TextStyle titleStyle =
      TextStyle(color: mainBrown, fontSize: 20.0, fontFamily: 'CN Rocks');
  Map<String, dynamic> options = {
    "degrees": [1, 2],
    "nbStances": [5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
    "intervals": [2, 3, 4, 5, 10],
  };

  Map<String, dynamic> selectedOptions = {
    "degree": 1,
    "nbStances": 5,
    "intervals": 2,
  };

  Timer timer;
  Timer awaiting;
  int _counter = 0;
  Timer countdown;
  int _countdownTime = 5;
  bool _enableThemeSong = true;

  ButtonState buttonState;
  static AudioCache player = AudioCache();
  static AudioCache bgSound = AudioCache();
  AudioPlayer themeSong;
  AudioPlayer stanceAudio;

  @override
  void initState() {
    buttonState = ButtonState.stopped;
    getOptions();
    super.initState();
  }

  Future getOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isThemeSongEnabled = prefs.getBool('themeSong');
    if (isThemeSongEnabled != null) {
      _enableThemeSong = isThemeSongEnabled;
    }
  }

  @override
  void dispose() {
    bgSound.clearCache();
    player.clearCache();
    super.dispose();
  }

  void _initStances() async {
    final stances = Stances();
    final filteredStances =
        stances.getStancesByDegree(degree: selectedOptions['degree']);

    _startCountdown();

    awaiting = Timer(Duration(seconds: 5), () async {
      if (buttonState != ButtonState.stopped) {
        if (_enableThemeSong) {
          themeSong = await bgSound.loop('audio/theme_ip.mp3', volume: 0.2);
        }
        _switchStance(stances, filteredStances);

        timer = Timer.periodic(Duration(seconds: selectedOptions['intervals']),
            (_) {
          if (_counter < selectedOptions['nbStances']) {
            _switchStance(stances, filteredStances);
          } else {
            setState(() {
              buttonState = ButtonState.stopped;
            });
            _stopCounter();
          }
        });
      }
    });
  }

  void _startCountdown() {
    setState(() {
      buttonState = ButtonState.countdown;
    });
    countdown = Timer.periodic(Duration(seconds: 1), (_) {
      if (_countdownTime == 1) {
        setState(() {
          buttonState = ButtonState.playing;
        });

        countdown.cancel();
        _countdownTime = 5;
      } else {
        setState(() {
          _countdownTime--;
        });
      }
    });
  }

  void _switchStance(Stances stances, List<Stance> filteredStances) async {
    setState(() {
      selectedStance = stances.getRandomStance(stances: filteredStances);
      _counter++;
    });
    stanceAudio = await player.play(selectedStance.audio);
  }

  void _stopCounter() {
    setState(() {
      _countdownTime = 5;
      _counter = 0;
      buttonState = ButtonState.stopped;
    });

    awaiting?.cancel();
    countdown?.cancel();
    timer?.cancel();
    themeSong?.stop();
    stanceAudio?.stop();
  }

  void onSelectedItem(int index, List list, String field) {
    selectedOptions[field] = list[index];
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = buttonState == ButtonState.playing ||
        buttonState == ButtonState.countdown;
    String buttonText;
    switch (buttonState) {
      case ButtonState.countdown:
        buttonText = _countdownTime.toString();
        break;
      case ButtonState.playing:
        buttonText = selectedStance != null ? selectedStance.name : '';
        break;
      case ButtonState.stopped:
        buttonText = 'GO';
        break;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Image.asset(
            'assets/wc__bg.jpg',
            fit: BoxFit.cover,
          )),
          ListView(
            children: <Widget>[
              AppBar(
                title: new Text(
                  "詠春",
                  style: TextStyle(color: Colors.white, fontSize: 35.0),
                ),
                backgroundColor: Colors.transparent,
                flexibleSpace: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(-60.0, -50.0)
                          ..scale(1.0, 2.0),
                        child: SvgPicture.asset(
                          'assets/brush_trace.svg',
                          width: 50.0,
                          height: 80.0,
                          color: mainBrown,
                        ),
                      ),
                    ),
                    Container(
                      width: 80.0,
                      height: 80.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              width: 80.0,
                              height: 80.0,
                              child: SvgPicture.asset(
                                'assets/brush_splash_simple.svg',
                                fit: BoxFit.cover,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SwitchListTile(
                                          title: const Text('Musique de fond'),
                                          subtitle: const Text(
                                              'S\'active lors de de l\'exercice'),
                                          value: _enableThemeSong,
                                          activeColor: Colors.redAccent,
                                          onChanged: _enableThemeOpts,
                                          secondary:
                                              const Icon(Icons.music_note),
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 5.0),
                              child: Center(
                                  child: SvgPicture.asset(
                                'assets/settings-icon.svg',
                                width: 25.0,
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                elevation: 0.0,
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                curve: cubicEase,
                opacity: isActive ? 0.0 : 1.0,
                child: Column(
                  children: <Widget>[
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
                  ],
                ),
              ),
            ],
          ),
          AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: cubicEase,
              left: 0,
              right: 0,
              bottom: isActive ? MediaQuery.of(context).size.width / 2 : 40.0,
              child: _buildGoBtn(buttonText, isActive)),
        ],
      ),
//      floatingActionButton: RawMaterialButton(
//          child: Container(
//            width: 80.0,
//            height: 80.0,
//            child: SvgPicture.asset(
//              'assets/brush_splash.svg',
//              fit: BoxFit.cover,
//              color: Colors.redAccent,
//            ),
//          ),
//          onPressed: () {
//            print('other page stances');
//          }),
    );
  }

  void _enableThemeOpts(bool value) async {
    setState(() {
      _enableThemeSong = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeSong', value);
  }

  GestureDetector _buildGoBtn(String buttonText, bool isActive) {
    double btnSize = isActive ? 270.0 : 200.0;
    return GestureDetector(
      onTap: isActive ? null : _initStances,
      child: Center(
        child: AnimatedContainer(
          width: btnSize,
          height: btnSize,
          curve: cubicEase,
          duration: Duration(milliseconds: 500),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned.fill(
                  child: SvgPicture.asset(
                'assets/go_bg.svg',
                fit: BoxFit.cover,
                color: mainBrown,
              )),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: cubicEase,
                  switchOutCurve: cubicEase,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      child: ScaleTransition(child: child, scale: animation),
                      opacity: animation,
                    );
                  },
                  child: Text(
                    buttonText,
                    key: ValueKey<String>(buttonText),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            buttonState == ButtonState.playing ? 50.0 : 120.0,
                        fontFamily: (buttonState == ButtonState.playing ||
                                buttonState == ButtonState.stopped)
                            ? 'CN takeway'
                            : 'CN rocks'),
                  ),
                ),
              ),
              Positioned(
                bottom: -30.0,
                left: 0,
                right: 0,
                child: isActive
                    ? GestureDetector(
                        onTap: _stopCounter,
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          child: Stack(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/brush_splash_simple.svg',
                                fit: BoxFit.contain,
                                color: Colors.redAccent,
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
