import 'package:flutter/material.dart';
import 'package:run_length_encoding/constants.dart';
import 'package:run_length_encoding/home_page.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
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
      home: const HomePage(),
    );
  }
}
