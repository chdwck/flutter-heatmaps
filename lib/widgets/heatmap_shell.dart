import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:heatmap/style.dart';
import 'package:heatmap/utils/heatmap.dart';

class HeatmapShell extends StatefulWidget {
  const HeatmapShell({super.key, required this.locations});

  final List<LatLng> locations;

  @override
  State<HeatmapShell> createState() => _HeatmapShellState();
}

class _HeatmapShellState extends State<HeatmapShell>
{
    final String styleJsonStr = '[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"},{"visibility":"off"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]';
    final Completer<GoogleMapController> _controller = Completer();

    final CameraPosition _murica = const CameraPosition(
      target: LatLng(49.02409926515028, -94.3653444573283),
      zoom: 3.25,
    );

    Set<Circle> circles = {};

    bool _loaded = false;
    bool _passedFirstRender = false;

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    controller.setMapStyle(styleJsonStr);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _loaded = true);
    });
  }

  void updateCircles() {
     var condensed = condenseCoordinates(coordinates: widget.locations, distance: 500);
     var colorScale = ColorScale(condensed);

     circles = condensed.map((HeatmapCoordinate hCoord) {
        return Circle(
          circleId: CircleId(hCoord.toString()),
          center: hCoord.coordinate,
          radius: (600 * hCoord.weight).toDouble(),
          fillColor: colorScale.color(hCoord.weight),
          strokeWidth: 0,
        );
      }).toSet();
  }

    @override
    void initState()
    {
      super.initState();
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _passedFirstRender = true;
          updateCircles();
        });
      });
    }

    @override
    Widget build(BuildContext buildContext)
    {
      return Stack(children: [
        if (_passedFirstRender) GoogleMap(
          mapType: MapType.normal,
          circles: circles,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: false,
          initialCameraPosition: _murica,
          onMapCreated: onMapCreated,
          onCameraMove: null,
          onTap: null,
          myLocationButtonEnabled: false,
        ),
        if (!_loaded) Container(
          height: double.infinity,
          color: dark800,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator())
        )
      ]);
    }
}