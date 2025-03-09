import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color lightBlack = Color(0xFF333333);
  static const Color green = Color(0xFF00FF00);
  static const Color deepGreen = Color.fromARGB(255, 23, 100, 0);
  static const Color greywhite = Color.fromARGB(255, 243, 243, 243);
  static const Color greenAccent = Color(0xFF00FF88);
  static const Color greenGrey = Color(0xFF88FF88);
  static const Color grey = Colors.grey;
}

class AppGradients {
  static const Gradient blackToLightBlack = LinearGradient(
    colors: [AppColors.black, AppColors.lightBlack],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient greenToGreenAccent = LinearGradient(
    colors: [AppColors.green, AppColors.greenAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient greenAccentToGreenGrey = LinearGradient(
    colors: [AppColors.greenAccent, AppColors.greenGrey],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient blackToGreen = LinearGradient(
    colors: [AppColors.black, AppColors.green],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient lightBlackToGreenGrey = LinearGradient(
    colors: [AppColors.lightBlack, AppColors.greenGrey],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
