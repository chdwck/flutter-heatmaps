import 'package:flutter/material.dart';
import 'package:heatmap/style.dart';
import 'package:heatmap/widgets/list_card.dart';

class Home extends StatefulWidget {
  const Home({super.key });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Home> createState() => _HomeState();
}

class CsvDataset {
  final String title;
  final String csvPath;

  CsvDataset(this.title, this.csvPath);
}

class _HomeState extends State<Home> {
  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: dark900,
    title: const Text("American Heatmaps")
  );

  final List<CsvDataset> datasets = [
    CsvDataset('Fast Food Restuarants', 'assets/data/fastFoodRestaurantsLatLng.csv'),
    CsvDataset('Hospitals', 'assets/data/hostpitalLatLng.csv'),
    CsvDataset('Broken Mcdonalds Ice Cream Machines', 'assets/data/mcdonaldsBrokenIcecreamLatLng.csv',),
    CsvDataset('Small Dataset for Testing', 'assets/data/small.csv'),
  ];

  Widget get makeBody => Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: datasets.length,
      itemBuilder: (BuildContext context, int index) {
        var dataset = datasets[index];
        return ListCard(title: dataset.title, csvPath: dataset.csvPath);
      })
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: topAppBar,
      backgroundColor: dark800,
      body: makeBody,
      floatingActionButton: null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}