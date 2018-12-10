import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pwts_app/abstracts.dart';
import 'package:pwts_app/models/stance.dart';
import 'package:pwts_app/resources/stances_data.dart';

class Stances {
  List<Stance> getStancesByStyle({@required WingChunStyle style, int degree}) {
    return allStances.where((Stance stance) {
      if (degree != null) {
        return stance.style.contains(describeEnum(style)) &&
            stance.degree.contains(degree);
      } else {
        return stance.style.contains(describeEnum(style));
      }
    }).toList();
  }

  List<Stance> getStancesByDegree({@required int degree}) {
    return allStances
        .where((Stance stance) => stance.degree.contains(degree))
        .toList();
  }

  List<Stance> getShuffledStances({@required List<Stance> stances}) {
    stances.shuffle();
    return stances;
  }

  Stance getRandomStance({@required List<Stance> stances}) {
    Random random = Random();
    int i = random.nextInt(stances.length - 1);
    return stances[i];
  }
}
