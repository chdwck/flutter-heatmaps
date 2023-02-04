import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:heatmap/utils/csv.dart';

void main() {
  test('parseCsvString handles an empty string', () {
    expect(parseCsvString(''), []);
  });

  test('parseCsvString handles a single row', () {
    expect(parseCsvString('1,2'), const [LatLng(1, 2)]);
  });

  test('parseCsvString handles multiple rows', () {
    var actual = parseCsvString('1,2\n3,4\n56.1,2');
    var expected = const [LatLng(1, 2), LatLng(3, 4), LatLng(56.1, 2)];
    expect(actual, expected);
  });
}