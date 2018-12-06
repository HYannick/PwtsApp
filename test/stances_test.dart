// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:pwts_app/resources/stances.dart';

void main() {
  group('Stances', () {
    Stances stances;
    setUpAll(() {
      stances = Stances();
    });

    test('Should have 4 stances on first degree', () {
      final List<Map<String, dynamic>> stancesList =
          stances.getStancesByDegree(degree: 1);
      expect(stancesList.length, 4);
    });

    test('Should have Sifu style', () {
      final List<Map<String, dynamic>> stancesList =
          stances.getStancesByStyle(style: 'sifu');
      expect(stancesList.length, 7);
    });

    test('Should have 7 Sifu style for second degree', () {
      final List<Map<String, dynamic>> stancesList =
          stances.getStancesByStyle(degree: 2, style: 'sifu');
      expect(stancesList.length, 7);
    });
    test('Should have 4 daisihing style for first degree', () {
      final List<Map<String, dynamic>> stancesList =
          stances.getStancesByStyle(degree: 1, style: 'daisihing');
      expect(stancesList.length, 4);
    });

    test('Should select a random stance', () {
      final selectedStance = stances.getRandomStance(
          stances: stances.getStancesByDegree(degree: 1));
      print(selectedStance);
    });
  });
}
