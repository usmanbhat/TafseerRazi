import 'dart:convert';
import 'dart:html' as html; // Import for web-specific functionality
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../widgets/styled_text.dart';
import '../pages/settings_page.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

// Use metadata updates only if on the web

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

    // Set initial metadata
    if (kIsWeb) {
      updateMetaTags(
        widget.surah['stitle'] ?? 'Surah Title',
        'Explore details of the Surah and its Ayahs dynamically.',
      );
    }
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
      //print('Error loading JSON: $e');
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
        // Dynamically update metadata
        if (kIsWeb) {
          updateMetaTags(
            surahData[currentIndex]['title'] ?? 'Ayah Title',
            surahData[currentIndex]['details'] ?? 'Ayah details or translation',
          );
        }
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

  void updateMetaTags(String title, String description) {
    // Update the page title
    html.document.title = title;

    // Remove existing meta description
    final existingDescription = html.document.head!
        .querySelector('meta[name="description"]') as html.MetaElement?;
    existingDescription?.remove();

    // Add new meta description
    final descriptionMeta = html.MetaElement()
      ..name = 'description'
      ..content = description;
    html.document.head!.append(descriptionMeta);

    // Optional: Add keywords for SEO
    final existingKeywords = html.document.head!
        .querySelector('meta[name="keywords"]') as html.MetaElement?;
    existingKeywords?.remove();

    final keywordsMeta = html.MetaElement()
      ..name = 'keywords'
      ..content = 'Quran, Ayah, Surah, $title';
    html.document.head!.append(keywordsMeta);
  }

  String limitText(String text) {
    List<String> words = text.split(' ');
    if (words.length > 6) {
      return words.take(6).join(' ') + '...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
      drawerColor = const Color(0xFFF4E1C1);
      textColor = Colors.brown[900]!;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.surah['stitle'],
                style: const TextStyle(
                  fontFamily: 'QuranNames',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
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
                    Flexible(
                      child: ListView(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: drawerColor,
                              border: Border.all(
                                color: textColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              surahData[currentIndex]['title'] ?? '',
                              style: TextStyle(
                                fontSize: textSize + 4,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quran',
                                color: textColor,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          StyledTextWithBraces(
                            text: surahData[currentIndex]['details'],
                            textSize: textSize,
                            fontFamily: fontFamily,
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
                          onPressed: () {
                            if (currentIndex > 0) {
                              navigateToAyah(currentIndex - 1);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
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
    );
  }
}
