import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class HeatmapCoordinate
{
  LatLng coordinate;
  int weight;

  HeatmapCoordinate({ required this.coordinate, this.weight = 1 });
}

const int earthRadius = 6371; // km

double geoDistanceKm(LatLng a, LatLng b)
{
  return earthRadius * acos(
    sin(a.latitude) * sin(b.latitude) +
    cos(a.latitude) * cos(b.latitude) * 
    cos(b.longitude - a.longitude));
}

List<HeatmapCoordinate> condenseCoordinates({ 
  required List<LatLng> coordinates, 
  int distance = 100
})
{
  var condensedCoordinates = <HeatmapCoordinate>[];

  for (var coordinate in coordinates)
  {
    var existing = condensedCoordinates.firstWhere(
      (HeatmapCoordinate c) => geoDistanceKm(c.coordinate, coordinate) < distance,
      orElse: () => HeatmapCoordinate(coordinate: coordinate, weight: -1));

    // Found one with 100 km
    if (existing.weight > 0)
    {
      existing.weight++;
    } else {
      existing.weight = 1;
      condensedCoordinates.add(existing);
    }
  }

  return condensedCoordinates;
}

class ColorScale
{
  late List<Color> colors;

  static HSLColor base = const HSLColor.fromAHSL(1.0, 178, 1.0, .51);

  ColorScale(List<HeatmapCoordinate> cooridnates)
  {
    var sorted = List.from(cooridnates);
    sorted.sort((a, b) => b.weight - a.weight);

    var lowest = sorted.last.weight;
    var highest = sorted.first.weight;

    int range = highest - lowest + 2;
    double hueRange = 360 - base.hue;

    var colors = <Color>[];

    for (int i = lowest; i <= range; i++) 
    {
      var nextHue = base.hue + hueRange * (i / range);
      var nextColor = HSLColor.fromAHSL(
        base.alpha,
        nextHue,
        base.saturation,
        base.lightness
      );

      colors.add(nextColor.toColor());
    }

    this.colors = colors;
  }

  Color color(int value)
  {
    return colors[value];
  }
}