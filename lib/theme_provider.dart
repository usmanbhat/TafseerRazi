import 'package:flutter/material.dart';

// Define the enum for different themes
enum AppTheme {
  // ignore: constant_identifier_names
  LightTheme,
  // ignore: constant_identifier_names
  DarkTheme,
  // ignore: constant_identifier_names
  CustomTheme, // Sepia theme as custom
}

extension AppThemeData on AppTheme {
  ThemeData get data {
    switch (this) {
      case AppTheme.DarkTheme:
        return ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );

      case AppTheme.LightTheme:
        return ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );

      case AppTheme.CustomTheme:
      default:
        return ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primaryColor: const Color(0xFF72603F),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF72603F),
            secondary: const Color(0xFF8D774E),
            background: const Color(0xFFF8EBD5),
            surface: const Color(0xFFF4E1C1),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: const Color(0xFF010101),
            onSurface: const Color(0xFF010101),
          ),
          scaffoldBackgroundColor:
              const Color(0xFFF8EBD5), // Sepia theme background
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF72603F),
            titleTextStyle: TextStyle(color: Color(0xFFF8EBD5), fontSize: 20),
          ),
          textTheme: const TextTheme(
            bodyMedium:
                TextStyle(color: Color(0xFF010101), fontFamily: 'Quran'),
            bodyLarge: TextStyle(color: Color(0xFF010101), fontFamily: 'Quran'),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFF4E1C1)),
          buttonTheme: const ButtonThemeData(
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
