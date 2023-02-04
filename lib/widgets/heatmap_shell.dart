import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeatmapShell extends StatefulWidget {
  const HeatmapShell({super.key, required this.locations});

  final List<LatLng> locations;

  @override
  State<HeatmapShell> createState() => _HeatmapShellState();
}

class _HeatmapShellState extends State<HeatmapShell>
{
    final Completer<GoogleMapController> _controller = Completer();

    final CameraPosition _murica = const CameraPosition(
      target: LatLng(49.02409926515028, -94.3653444573283),
      zoom: 3.25,
    );

    Set<Circle> circles = {};

    @override
    void initState()
    {
      super.initState();
      print("init");
      circles = widget.locations.map((LatLng location) {
        return Circle(
          circleId: CircleId(location.toString()),
          center: location,
          radius: 100000,
          fillColor: Colors.red.withOpacity(0.2),
          strokeWidth: 0,
        );
      }).toSet();
      print(circles.length);
    }

    @override
    Widget build(BuildContext buildContext)
    {
      return GoogleMap(
          mapType: MapType.normal,
          circles: circles,
          initialCameraPosition: _murica,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: null,
          onTap: null,
          myLocationButtonEnabled: false,
        );
    }
}