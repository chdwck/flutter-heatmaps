import 'package:flutter/material.dart';
import 'package:heatmap/screens/heatmap/heatmap.dart';

class ListItem extends StatefulWidget
{
  const ListItem({ super.key, required this.title, required this.csvPath });

  final String title;
  final String csvPath;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext buildContext) {
    return Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: ListTile(
              title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(buildContext).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Heatmap(title: widget.title, csvPath: widget.csvPath),
                ));
              },
            )));
  }
}
