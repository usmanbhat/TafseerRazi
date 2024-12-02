import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  double fontSize = 16;
  String fontFamily = 'Noto';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load settings from SharedPreferences
  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize =
          prefs.getDouble('fontSize') ?? 16; // Default to 16 if no value exists
      fontFamily = prefs.getString('fontFamily') ?? 'Noto'; // Default to 'Noto'
    });
  }

  // Save settings to SharedPreferences
  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', fontSize);
    prefs.setString('fontFamily', fontFamily);
    // Optionally show a snackbar or dialog indicating the settings were saved
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Font Size', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.minus),
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  onPressed: () {
                    setState(() {
                      if (fontSize > 12) fontSize -= 1;
                    });
                  },
                  iconSize: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                Text(
                  fontSize.toStringAsFixed(0),
                  style: TextStyle(fontSize: fontSize, fontFamily: fontFamily),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.plus),
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  onPressed: () {
                    setState(() {
                      if (fontSize < 24) fontSize += 1;
                    });
                  },
                  iconSize: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Font Type', style: TextStyle(fontSize: 20)),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fontFamily = 'Noto';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    backgroundColor: fontFamily == 'Noto'
                        ? Colors.blue
                        : null, // Highlight the selected font
                  ),
                  child:
                      const Text('Noto', style: TextStyle(fontFamily: 'Noto')),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fontFamily = 'Amiri';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    backgroundColor: fontFamily == 'Amiri'
                        ? Colors.blue
                        : null, // Highlight the selected font
                  ),
                  child: const Text('Amiri',
                      style: TextStyle(fontFamily: 'Amiri')),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fontFamily = 'noor';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    backgroundColor: fontFamily == 'noor'
                        ? Colors.blue
                        : null, // Highlight the selected font
                  ),
                  child:
                      const Text('noor', style: TextStyle(fontFamily: 'noor')),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Theme', style: TextStyle(fontSize: 20)),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Change theme to Light
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setTheme(AppTheme.LightTheme);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  child: const FaIcon(FontAwesomeIcons.sun, size: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Change theme to Dark
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setTheme(AppTheme.DarkTheme);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  child: const FaIcon(FontAwesomeIcons.moon, size: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Change theme to Sepia
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setTheme(AppTheme.CustomTheme);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  child: const FaIcon(FontAwesomeIcons.bookOpen, size: 24),
                ),
              ],
            ),
            // Save Button
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _saveSettings(); // Save settings when pressed
                Navigator.pop(
                    context, true); // Close the settings page and return true
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              ),
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
