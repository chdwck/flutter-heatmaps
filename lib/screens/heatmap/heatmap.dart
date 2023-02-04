import 'package:flutter/material.dart';
import 'package:heatmap/widgets/heatmap_from_csv.dart';
import 'package:heatmap/style.dart';

class Heatmap extends StatelessWidget {
  const Heatmap({super.key, required this.title, required this.csvPath});

  final String title;
  final String csvPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark800,
      appBar: AppBar(
          elevation: 0.1,
          backgroundColor: dark900,
          title: Text(title)),
      body: HeatmapFromCsv(pathToCsv: csvPath),
    );
  }
}
