import 'package:flutter/material.dart';

// States
enum ButtonState { countdown, playing, stopped }

// Easings
const Cubic cubicEase = const Cubic(0.8, 0, 0.2, 1);

// Colors
const Color mainBrown = Color.fromRGBO(41, 23, 34, 1.0);
const Color mainRed = Colors.redAccent;
const Color mainLight = Colors.white;

// Font Family
const String familyMain = 'CN Rocks';
const String familySecondary = 'CN takeway';

// Paths
const String activeBtnSVG = 'assets/brush_splash.svg';
const String inactiveBtnSVG = 'assets/brush_splash_simple.svg';
const String mainTheme = 'audio/theme_ip.mp3';
const String backgroundImage = 'assets/wc__bg.jpg';
