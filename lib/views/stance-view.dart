import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pwts_app/abstracts.dart';
import 'package:pwts_app/components/options-list.dart';
import 'package:pwts_app/components/options-modal.dart';
import 'package:pwts_app/models/stance.dart';
import 'package:pwts_app/resources/stances.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StanceTraining extends StatefulWidget {
  StanceTraining({Key key}) : super(key: key);

  @override
  _StanceTrainingState createState() => _StanceTrainingState();
}

class _StanceTrainingState extends State<StanceTraining> {
  Map<String, dynamic> _options = {
    "degrees": <int>[1, 2],
    "nbStances": <int>[5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
    "intervals": <int>[2, 3, 4, 5, 10],
  };

  Map<String, dynamic> _selectedOptions = {
    "degree": 1,
    "nbStances": 5,
    "intervals": 2,
  };

  Timer _timer;
  Timer _awaitingCountdown;
  Timer _countdown;

  int _counter = 0;
  int _countdownTime = 3;

  bool _enableThemeSong = true;
  WingChunStyle _wcStyle = WingChunStyle.daisihing;

  ButtonState _buttonState = ButtonState.stopped;

  static AudioCache _player = AudioCache();
  static AudioCache _bgSound = AudioCache();

  AudioPlayer _themeSong;
  AudioPlayer _stanceAudio;

  Stance _selectedStance;

  @override
  void initState() {
    super.initState();
    _getOptions();
  }

  @override
  void dispose() {
    _bgSound.clearCache();
    _player.clearCache();
    super.dispose();
  }

  Future _getOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isThemeSongEnabled = prefs.getBool('themeSong');
    final int wingChunStyle = prefs.getInt('wcStyle');

    if (isThemeSongEnabled != null) {
      _enableThemeSong = isThemeSongEnabled;
    }
    if (wingChunStyle != null) {
      _wcStyle = WingChunStyle.values[wingChunStyle];
    }
  }

  void _updateOptions({style, enableThemeSong}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeSong', enableThemeSong);
    await prefs.setInt('wcStyle', WingChunStyle.values.indexOf(style));
    setState(() {
      _enableThemeSong = enableThemeSong;
      _wcStyle = style;
    });
  }

  void _initStances() async {
    final stances = Stances();
    final filteredStances = stances.getStancesByStyle(
        degree: _selectedOptions['degree'], style: _wcStyle);

    _startCountdown();

    _awaitingCountdown = Timer(Duration(seconds: _countdownTime), () async {
      if (_buttonState != ButtonState.stopped) {
        if (_enableThemeSong) {
          _themeSong = await _bgSound.loop(mainTheme, volume: 0.2);
        }
        _switchStance(stances, filteredStances);

        _timer = Timer.periodic(
            Duration(seconds: _selectedOptions['intervals']), (_) {
          if (_counter < _selectedOptions['nbStances']) {
            _switchStance(stances, filteredStances);
          } else {
            setState(() {
              _buttonState = ButtonState.stopped;
            });
            _stopCounter();
          }
        });
      }
    });
  }

  void _startCountdown() {
    setState(() {
      _buttonState = ButtonState.countdown;
    });
    _countdown = Timer.periodic(Duration(seconds: 1), (_) {
      if (_countdownTime == 1) {
        setState(() {
          _buttonState = ButtonState.playing;
        });

        _countdown.cancel();
        _countdownTime = 3;
      } else {
        setState(() {
          _countdownTime--;
        });
      }
    });
  }

  void _switchStance(Stances stances, List<Stance> filteredStances) async {
    setState(() {
      _selectedStance = stances.getRandomStance(stances: filteredStances);
      _counter++;
    });
    _stanceAudio = await _player.play(_selectedStance.audio);
  }

  void _stopCounter() {
    setState(() {
      _countdownTime = 3;
      _counter = 0;
      _buttonState = ButtonState.stopped;
    });

    _awaitingCountdown?.cancel();
    _countdown?.cancel();
    _timer?.cancel();
    _themeSong?.stop();
    _stanceAudio?.stop();
  }

  void onSelectedItem(int index, List list, String field) {
    _selectedOptions[field] = list[index];
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = _buttonState == ButtonState.playing ||
        _buttonState == ButtonState.countdown;
    String buttonText;
    switch (_buttonState) {
      case ButtonState.countdown:
        buttonText = _countdownTime.toString();
        break;
      case ButtonState.playing:
        buttonText = _selectedStance != null ? _selectedStance.name : '';
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
            backgroundImage,
            fit: BoxFit.cover,
          )),
          ListView(
            children: <Widget>[
              AppBar(
                title: Text(
                  "詠春",
                  style: TextStyle(
                      color: mainLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      fontFamily: familyTertiary),
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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (_) => OptionsModal(
                                enableThemeSong: _enableThemeSong,
                                style: _wcStyle,
                                updateOptions: _updateOptions));
                      },
                      child: buildSettingsBtn(),
                    )
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
                      list: _options['degrees'],
                      title: 'Degré',
                      field: 'degree',
                      onSelectedItem: onSelectedItem,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    OptionsList(
                      list: _options['nbStances'],
                      title: 'Nombre de mouvements',
                      field: 'nbStances',
                      onSelectedItem: onSelectedItem,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    OptionsList(
                      list: _options['intervals'],
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
//      TODO: Do the redirection for stances listing
//      floatingActionButton: RawMaterialButton(
//          child: Container(
//            width: 80.0,
//            height: 80.0,
//            child: SvgPicture.asset(
//              'assets/brush_splash.svg',
//              fit: BoxFit.cover,
//              color: mainRed,
//            ),
//          ),
//          onPressed: () {
//            print('other page stances');
//          }),
    );
  }

  Container buildSettingsBtn() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              width: 80.0,
              height: 80.0,
              child: SvgPicture.asset(
                inactiveBtnSVG,
                fit: BoxFit.cover,
                color: mainRed,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5.0),
            child: Center(
                child: SvgPicture.asset(
              'assets/settings-icon.svg',
              width: 25.0,
            )),
          ),
        ],
      ),
    );
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
                child: _buildTextSwitcher(buttonText),
              ),
              _buildStopBtn(isActive)
            ],
          ),
        ),
      ),
    );
  }

  AnimatedSwitcher _buildTextSwitcher(String buttonText) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: cubicEase,
      switchOutCurve: cubicEase,
      transitionBuilder: (Widget child, Animation<double> animation) {
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
            color: mainLight,
            fontSize: _buttonState == ButtonState.playing ? 50.0 : 120.0,
            fontFamily: (_buttonState == ButtonState.playing ||
                    _buttonState == ButtonState.stopped)
                ? familySecondary
                : familyMain),
      ),
    );
  }

  Positioned _buildStopBtn(bool isActive) {
    return Positioned(
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
                      inactiveBtnSVG,
                      fit: BoxFit.contain,
                      color: mainRed,
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.stop,
                          color: mainLight,
                          size: 30.0,
                        ),
                      ),
                    )
                  ],
                ),
              ))
          : Container(),
    );
  }
}
