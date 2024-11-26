import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Font Size', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.minus),
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  onPressed: () {
                    setState(() {
                      if (fontSize > 12) fontSize -= 1;
                    });
                  },
                  iconSize: 32,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                Text(
                  fontSize.toStringAsFixed(0),
                  style: TextStyle(fontSize: fontSize, fontFamily: fontFamily),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.plus),
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  onPressed: () {
                    setState(() {
                      if (fontSize < 24) fontSize += 1;
                    });
                  },
                  iconSize: 32,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Font Type', style: TextStyle(fontSize: 20)),
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
                  child: Text('Noto', style: TextStyle(fontFamily: 'Noto')),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    backgroundColor: fontFamily == 'Noto'
                        ? Colors.blue
                        : null, // Highlight the selected font
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fontFamily = 'Amiri';
                    });
                  },
                  child: Text('Amiri', style: TextStyle(fontFamily: 'Amiri')),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    backgroundColor: fontFamily == 'Amiri'
                        ? Colors.blue
                        : null, // Highlight the selected font
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fontFamily = 'noor';
                    });
                  },
                  child: Text('noor', style: TextStyle(fontFamily: 'noor')),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    backgroundColor: fontFamily == 'noor'
                        ? Colors.blue
                        : null, // Highlight the selected font
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Theme', style: TextStyle(fontSize: 20)),
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
                  child: FaIcon(FontAwesomeIcons.sun, size: 24),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Change theme to Dark
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setTheme(AppTheme.DarkTheme);
                  },
                  child: FaIcon(FontAwesomeIcons.moon, size: 24),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Change theme to Sepia
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setTheme(AppTheme.CustomTheme);
                  },
                  child: FaIcon(FontAwesomeIcons.bookOpen, size: 24),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
              ],
            ),
            // Save Button
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _saveSettings(); // Save settings when pressed
                Navigator.pop(
                    context, true); // Close the settings page and return true
              },
              child: Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
