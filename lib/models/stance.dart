import 'package:flutter/material.dart';

class Stance {
  final String name;
  final String audio;
  final List<int> degree;
  final List<String> style;

  Stance(
      {@required this.name,
      @required this.audio,
      @required this.degree,
      @required this.style});
}
