import 'package:flutter/material.dart';
import 'package:run_length_encoding/constants.dart';
import 'package:run_length_encoding/interactive_grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run-Length-Encoding',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const InteractiveGrid(),
    );
  }
}
