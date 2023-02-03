import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Heatmap extends StatefulWidget {
  const Heatmap({super.key});

  @override
  State<Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
    final Completer<GoogleMapController> _controller = Completer();

    final CameraPosition _murica = const CameraPosition(
      target: LatLng(49.02409926515028, -94.3653444573283),
      zoom: 3.25,
    );

    @override
    Widget build(BuildContext buildContext)
    {
      return GoogleMap(
          initialCameraPosition: _murica,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: (position) => print(position),
          onTap: (latLng) => print(latLng),
          myLocationButtonEnabled: false,
        );
    }
}