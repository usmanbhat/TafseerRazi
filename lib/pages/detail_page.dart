import 'dart:convert';
import '/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> surah;

  const DetailsScreen({required this.surah, Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<dynamic> surahData = [];
  List<dynamic> filteredData = [];
  int currentIndex = 0;
  double textSize = 16.0; // Default text size
  String fontFamily = 'Noto'; // Default font
  String searchQuery = ''; // Search query for drawer

  @override
  void initState() {
    super.initState();
    loadSettings();
    loadSurahData();
  }

  Future<void> loadSurahData() async {
    try {
      final String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/surah_data_${widget.surah['sid']}.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      setState(() {
        surahData = jsonList;
        filteredData = jsonList; // Initially, display all data
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      textSize = prefs.getDouble('fontSize') ?? 16.0;
      fontFamily = prefs.getString('fontFamily') ?? 'Noto';
    });
  }

  void navigateToAyah(int index) {
    if (index >= 0 && index < surahData.length) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredData = surahData.where((ayah) {
        return ayah['normal'].toString().contains(query);
      }).toList();
    });
  }

  String limitText(String text) {
    List<String> words = text.split(' ');
    if (words.length > 6) {
      return words.take(6).join(' ') + '...';
    }
    return text;
  }

  TextSpan styleTextWithBraces(String text) {
    final regex = RegExp(r'\{(.*?)\}');
    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    Color textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    regex.allMatches(text).forEach((match) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
              fontSize: textSize, fontFamily: fontFamily, color: textColor),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
            color: Colors.blue, fontSize: textSize, fontFamily: 'Quran'),
      ));
      lastMatchEnd = match.end;
    });

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
            fontSize: textSize, fontFamily: fontFamily, color: textColor),
      ));
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.appTheme;

    Color drawerColor;
    Color textColor;
    if (themeMode == AppTheme.DarkTheme) {
      drawerColor = Colors.grey[850]!;
      textColor = Colors.white;
    } else if (themeMode == AppTheme.LightTheme) {
      drawerColor = Colors.white;
      textColor = Colors.black;
    } else {
      // Sepia theme
      drawerColor = Color(0xFFF4E1C1);
      textColor = Colors.brown[900]!;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Tooltip(
          message: 'Go back to Surah list',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.surah['stitle'],
                style: TextStyle(
                  fontFamily: 'QuranNames',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                if (result == true) {
                  setState(() {
                    loadSettings();
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: surahData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahData[currentIndex]['title'] ?? '',
                      style: TextStyle(
                        fontSize: textSize + 4,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quran',
                        color: textColor, // Apply text color
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          RichText(
                            text: styleTextWithBraces(
                              surahData[currentIndex]['details'] ?? '',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          onPressed: () {
                            if (currentIndex > 0) {
                              navigateToAyah(currentIndex - 1);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          onPressed: () {
                            if (currentIndex < surahData.length - 1) {
                              navigateToAyah(currentIndex + 1);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      endDrawer: buildDrawer(drawerColor, textColor),
    );
  }

  Drawer buildDrawer(Color drawerColor, Color textColor) {
    return Drawer(
      child: Container(
        color: drawerColor,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'بحث عن الآية',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: handleSearch,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final ayah = filteredData[index];
                    final title = limitText(ayah['title']);
                    return ListTile(
                      title: Text(
                        title,
                        style: TextStyle(
                          fontSize: textSize,
                          fontFamily: fontFamily,
                          color: textColor, // Apply text color
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        navigateToAyah(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
