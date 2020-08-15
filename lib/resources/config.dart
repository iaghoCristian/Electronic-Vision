import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  final double fontNormalParagraph = 14;
  final double fontNormalTitle = 16;
  final double fontAumenParagraph = 16;
  final double fontAumenTitle = 18;

  static Config config;

  static Config instance() {
    if (config == null) {
      config = Config();
    }
    return config;
  }

  Future<double> getPFont() async {
    if ((await getFont() == "Normal")) {
      return fontNormalParagraph;
    }
    return fontAumenParagraph;
  }

  Future<double> getTFont() async {
    if ((await getFont() == "Aumentada")) {
      return fontAumenTitle;
    } else {
      return fontNormalTitle;
    }
  }

  Future<Color> getColorToUse() async {
    if (await getColor() == "Azul") {
      return Color(0xff212178);
    } else {
      return Colors.red;
    }
  }

  Future<String> getFont() async {
    return (await SharedPreferences.getInstance()).getString("font");
  }

  Future<String> getColor() async {
    return (await SharedPreferences.getInstance()).getString("color");
  }
}
