import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:line_icons/line_icons.dart';
import 'package:run_length_encoding/interactive_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              js.context.callMethod('open', ['https://github.com/tobotis/RunLengthEncoding']);
            },
            icon: const Icon(LineIcons.github),
          ),
          IconButton(
            onPressed: () {
              js.context.callMethod('open', ['https://twitter.com/tobotis']);
            },
            icon: const Icon(
              LineIcons.twitter,
            ),
          ),
          IconButton(
            onPressed: () {
              js.context.callMethod('open', ['http://tobotis.com']);
            },
            icon: const Icon(
              LineIcons.link,
            ),
          ),
        ],
        title: const Text("tobotis.com", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: false,
      ),
      body: const InteractiveGrid(),
    );
  }
}
