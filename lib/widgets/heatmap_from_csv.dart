import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heatmap/widgets/heatmap_shell.dart';
import 'package:heatmap/utils/csv.dart';

class HeatmapFromCsv extends StatefulWidget {
  const HeatmapFromCsv({super.key, required this.pathToCsv});

  final String pathToCsv;

  @override
  State<HeatmapFromCsv> createState() => _HeatmapFromCsvState();
}

class _HeatmapFromCsvState extends State<HeatmapFromCsv>
{
    List<LatLng> locations = [];
    bool _loading = true;
    bool _error = false;

    @override
    void initState()
    {
      super.initState();

      rootBundle.loadString(widget.pathToCsv)
        .then((String csvString) {
          setState(() {
            locations = parseCsvString(csvString);
            _loading = false;
          });
        })
        .catchError((Object error) {
          setState(() {
            _loading = false;
            _error = true;
          });
        });
    }

    @override
    Widget build(BuildContext buildContext)
    {
      if (_error) {
        return const Center(child: Text('Error loading CSV'));
      }

      if (_loading) {
        return const Center(child: CircularProgressIndicator());
      }

      return HeatmapShell(locations: locations);
    }
}