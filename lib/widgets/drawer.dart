import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/about_us_page.dart';
import '../pages/settings_page.dart';
import '../theme_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set the drawer color based on the current theme
    Color drawerColor;
    switch (themeProvider.appTheme) {
      case AppTheme.DarkTheme:
        drawerColor = Colors.grey[850]!;
        break;
      case AppTheme.LightTheme:
        drawerColor = Colors.white;
        break;
      case AppTheme.CustomTheme:
      default:
        drawerColor = const Color(0xFFF4E1C1); // Sepia theme background color
        break;
    }

    return Drawer(
      child: Container(
        color: drawerColor, // Set the drawer color dynamically
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color:
                    Color(0xFFB89B72), // Base color in case image fails to load
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 1, // Adjust opacity for the tint effect
                      child: Image.asset(
                        'assets/img/hero.jpg', // Replace with your image path
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingsPage())),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage())),
            ),
          ],
        ),
      ),
    );
  }
}
