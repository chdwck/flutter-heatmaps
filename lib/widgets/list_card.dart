import 'package:flutter/material.dart';
import 'package:heatmap/screens/heatmap/heatmap.dart';
import 'package:heatmap/style.dart';

class ListCard extends StatefulWidget
{
  const ListCard({ super.key, required this.title, required this.csvPath });

  final String title;
  final String csvPath;

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext buildContext) {
    return Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration:
                const BoxDecoration(color: dark700),
            child: ListTile(
              title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
              onTap: () {
                Navigator.of(buildContext).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Heatmap(title: widget.title, csvPath: widget.csvPath),
                ));
              },
            )));
  }
}
