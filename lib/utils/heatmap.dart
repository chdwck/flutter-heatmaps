import 'dart:math';
import 'package:tuple/tuple.dart';

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

class HeatArea {
  int density = 0;
  List<LatLng> edges = List.empty(growable: true);

  HeatArea({density, edges}) {
    this.density = density ?? 0;
    this.edges = edges ?? List.empty(growable: true);
  }

  void addEdge(LatLng edge) {
    density++;
    edges.add(edge);
  }

  void consildate() {
    // TODO: implement consildate
    // Perhaps "draw circles" to find edges and remove the center points
  }

  @override
  String toString() {
    return 'HeatArea{density: $density, edges: $edges}';
  }
}

class VisibleArea {
  final LatLng northWest;
  final LatLng southEast;
  
  late double smallestVisibleDistance;

  VisibleArea({required this.northWest, required this.southEast}) {
    smallestVisibleDistance = geoDistanceKm(northWest, southEast) / 10;
  }

  bool isVisible(LatLng coordinate) {
    return coordinate.latitude <= northWest.latitude &&
        coordinate.latitude >= southEast.latitude &&
        coordinate.longitude >= northWest.longitude &&
        coordinate.longitude <= southEast.longitude;
  }
}

List<HeatArea> getHeatAreas({
  required List<LatLng> coordinates,
  required VisibleArea visibleArea
}) {
  var flatEdges = <Tuple2<LatLng, int>>[];

  var areaIdx = 0;
  for (var coord in coordinates) {
    if (!visibleArea.isVisible(coord)) {
      continue;
    }

    var nearbyAnother = false;
    for (Tuple2<LatLng, int> edge in flatEdges) {
      nearbyAnother = geoDistanceKm(edge.item1, coord) <= visibleArea.smallestVisibleDistance;
      if (nearbyAnother) {
        flatEdges.add(Tuple2(coord, edge.item2));
        break;
      }
    }

    if (!nearbyAnother) {
      flatEdges.add(Tuple2(coord, areaIdx));
      areaIdx++;
    }
  }

  var areas = List.filled(areaIdx, null).map((e) => HeatArea()).toList();

  for (Tuple2<LatLng, int> edge in flatEdges) {
    areas[edge.item2].addEdge(edge.item1);
  }

  for (HeatArea area in areas) {
    area.consildate();
  }

  return areas;
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