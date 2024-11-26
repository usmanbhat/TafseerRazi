import 'package:flutter/material.dart';

// Define the enum for different themes
enum AppTheme {
  LightTheme,
  DarkTheme,
  CustomTheme, // Sepia theme as custom
}

extension AppThemeData on AppTheme {
  ThemeData get data {
    switch (this) {
      case AppTheme.DarkTheme:
        return ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );

      case AppTheme.LightTheme:
        return ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );

      case AppTheme.CustomTheme:
      default:
        return ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primaryColor: Color(0xFF72603F),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xFF72603F),
            secondary: Color(0xFF8D774E),
            background: Color(0xFFF8EBD5),
            surface: Color(0xFFF4E1C1),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: Color(0xFF010101),
            onSurface: Color(0xFF010101),
          ),
          scaffoldBackgroundColor: Color(0xFFF8EBD5), // Sepia theme background
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF72603F),
            titleTextStyle: TextStyle(color: Color(0xFFF8EBD5), fontSize: 20),
          ),
          textTheme: TextTheme(
            bodyMedium:
                TextStyle(color: Color(0xFF010101), fontFamily: 'Quran'),
            bodyLarge: TextStyle(color: Color(0xFF010101), fontFamily: 'Quran'),
          ),
          iconTheme: IconThemeData(color: Color(0xFFF4E1C1)),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF72603F),
            textTheme: ButtonTextTheme.primary,
          ),
        );
    }
  }
}

class ThemeProvider with ChangeNotifier {
  AppTheme _appTheme = AppTheme.CustomTheme;

  AppTheme get appTheme => _appTheme;

  void setTheme(AppTheme theme) {
    _appTheme = theme;
    notifyListeners();
  }

  ThemeData get theme => _appTheme.data;
}
