import 'package:wisp_ai/exports.dart'; // Import your AppColors and AppGradients

class ThemeProvider with ChangeNotifier {
  bool _isGreenTheme = false; // Track theme state

  bool get isGreenTheme => _isGreenTheme;

  ThemeData get themeData => _isGreenTheme ? _greenTheme : _darkTheme;

  void toggleTheme() {
    _isGreenTheme = !_isGreenTheme;
    notifyListeners();
  }

  // Define your Dark Theme
  static final ThemeData _darkTheme = ThemeData(
    primaryColor: AppColors.lightBlack,
    secondaryHeaderColor: AppColors.lightBlack,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: 'RobotoMono', color: AppColors.greywhite),
      bodyLarge: TextStyle(fontFamily: 'RobotoMono', color: AppColors.greywhite),
      bodyMedium: TextStyle(fontFamily: 'RobotoMono', color: AppColors.greywhite),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBlack,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'RobotoMono',
        fontSize: 20,
        color: AppColors.greywhite,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.lightBlack,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightBlack,
    ),
  );

  // Define your Green Theme
  static final ThemeData _greenTheme = ThemeData(
    primaryColor: AppColors.green,
    secondaryHeaderColor: AppColors.greenAccent,
    scaffoldBackgroundColor: AppColors.deepGreen,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: 'RobotoMono', color: AppColors.greywhite),
      bodyLarge: TextStyle(fontFamily: 'RobotoMono', color: AppColors.greywhite),
      bodyMedium: TextStyle(fontFamily: 'RobotoMono', color: AppColors.greywhite),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.green,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'RobotoMono',
        fontSize: 20,
        color: AppColors.greywhite,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.green,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.green,
    ),
  );

  // Get the current gradient based on the theme
  Gradient get currentGradient =>
      _isGreenTheme ? AppGradients.greenToGreenAccent : AppGradients.blackToLightBlack;
}
