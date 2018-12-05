import 'dart:math';

import 'package:meta/meta.dart';
import 'package:pwts_app/resources/stances_data.dart';

class Stances {
  List<Map<String, dynamic>> getStancesByStyle(
      {@required String style, int degree}) {
    return stancesList.where((Map<String, dynamic> stance) {
      if (degree != null) {
        return stance['style'].contains(style) &&
            stance['degree'].contains(degree);
      } else {
        return stance['style'].contains(style);
      }
    }).toList();
  }

  List<Map<String, dynamic>> getStancesByDegree({@required int degree}) {
    return stancesList.where((Map<String, dynamic> stance) {
      return stance['degree'].contains(degree);
    }).toList();
  }

  List<Map<String, dynamic>> getStances() => stancesList;

  List<Map<String, dynamic>> getShuffledStances(
      {@required List<Map<String, dynamic>> stances}) {
    stances.shuffle();
    return stances;
  }

  Map<String, dynamic> getRandomStance({@required stances}) {
    Random random = Random();
    int i = random.nextInt(stancesList.length - 1);
    return stances[i];
  }
}
