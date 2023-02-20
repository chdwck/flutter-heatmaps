import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:heatmap/utils/heatmap.dart';


void main() {

  test('VisibleArea.isVisible returns true if the coordinate is inside the area', () {
    var area = VisibleArea(northWest: const LatLng(1, -1), southEast: const LatLng(-1, 1));
    expect(area.isVisible(const LatLng(0, 0)), true);
    expect(area.isVisible(const LatLng(0.5, -1)), true);
    expect(area.isVisible(const LatLng(-0.5, 0.5)), true);
    expect(area.isVisible(const LatLng(1.5, 1.5)), false);
    expect(area.isVisible(const LatLng(-1.5, -1.5)), false);
    
    expect(area.isVisible(const LatLng(1, -1)), true);
    expect(area.isVisible(const LatLng(-1, 1)), true);
  });

  test('getHeatAreas returns a list of heat areas with the correct density', () {
    var area = VisibleArea(northWest: const LatLng(10, -10), southEast: const LatLng(-10, 10));

    var coordinates = [
      // out of visible area gets ignored
      const LatLng(11, -11),

      // area 1,
      const LatLng(0, 0), // gets swallowed by larger triangle
      const LatLng(-0.1, -0.1),
      const LatLng(-0.1, 0.1),
      const LatLng(0.1, 0),
      const LatLng(0.05, 0.05), // doesn't get swallowed by larger triangle since is edge

      // area 2 - all points appear
      const LatLng(9.0, 9.1),
      const LatLng(8.9, 9.0),
      const LatLng(8.8, 9.1),

      // outlier
      const LatLng(-9, 9),
    ];

    var expectedHeatAreas = [
      HeatArea(density: 5, edges: [
        const LatLng(0, 0), // TODO - remove to test consildate
        const LatLng(-0.1, -0.1),
        const LatLng(-0.1, 0.1),
        const LatLng(0.1, 0),
        const LatLng(0.05, 0.05),
      ]),
      HeatArea(density: 3, edges: [
        const LatLng(9.0, 9.1),
        const LatLng(8.9, 9.0),
        const LatLng(8.8, 9.1),
      ]),
      HeatArea(density: 1, edges: [
        const LatLng(-9, 9),
      ]),
    ];

    var actualHeatAreas = getHeatAreas(coordinates: coordinates, visibleArea: area);

    expect(actualHeatAreas.length, expectedHeatAreas.length);

    for (var i = 0; i < expectedHeatAreas.length; i++) {
      expect(actualHeatAreas[i].density, expectedHeatAreas[i].density);
      expect(actualHeatAreas[i].edges.length, expectedHeatAreas[i].edges.length);
      for (var j = 0; j < expectedHeatAreas[i].edges.length; j++) {
        var lookingFor = expectedHeatAreas[i].edges[j];
        var found = actualHeatAreas[i].edges.any(
          (edge) => edge.latitude == lookingFor.latitude && 
          edge.longitude == lookingFor.longitude);
        expect(found, true);
      }
    }
  });
}