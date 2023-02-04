import 'package:flutter/material.dart';
import 'package:heatmap/widgets/heatmap_from_csv.dart';

class Heatmap extends StatelessWidget {
  const Heatmap({super.key, required this.title, required this.csvPath});

  final String title;
  final String csvPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
          elevation: 0.1,
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          title: Text(title)),
      body: HeatmapFromCsv(pathToCsv: csvPath),
    );
  }
}
