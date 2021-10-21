import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  // static double defaultSize;
  // static Orientation orientation;
  static double standardWidth = 375.0;
  static double standardHeight = 815.0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    print("see screen width");
    print(screenWidth);

    if (screenWidth! > standardWidth) {
      screenWidth = standardWidth;
    } else {
      screenWidth = _mediaQueryData!.size.width;
    }
    if (screenHeight! > standardHeight) {
      screenHeight = standardHeight;
    } else {
      screenHeight = _mediaQueryData!.size.height;
    }
    // orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.standardHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.standardWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
