import 'package:ElectronicVision/pages/cart.dart';
import 'package:ElectronicVision/pages/home.dart';
import 'package:ElectronicVision/pages/splash.dart';
import 'package:ElectronicVision/resources/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: principalColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}
