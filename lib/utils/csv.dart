import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> parseCsvString(String csvString) {
  if (csvString.isEmpty) {
    return [];
  }

  return csvString
      .split('\n')
      .map((String row) => row.split(','))
      .map<LatLng>(
        (List<String> row) => 
          LatLng(double.parse(row[0]), double.parse(row[1])))
      .toList();
}