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