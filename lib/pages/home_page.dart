import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../pages/detail_page.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> surahs = [];

  @override
  void initState() {
    super.initState();
    loadSurahData();
  }

  void loadSurahData() async {
    String data =
        await DefaultAssetBundle.of(context).loadString('assets/surah.json');
    setState(() {
      surahs = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Determine the theme colors for the card based on the appTheme
    Color cardColor;
    Color textColor;
    Color backgroundColor;
    switch (themeProvider.appTheme) {
      case AppTheme.DarkTheme:
        cardColor = Colors.grey[850]!;
        textColor = Colors.white;
        backgroundColor = Colors.black;
        break;
      case AppTheme.LightTheme:
        cardColor = Colors.white;
        textColor = Colors.black;
        backgroundColor = Colors.white;
        break;
      case AppTheme.CustomTheme:
      default:
        // Sepia theme
        cardColor = const Color(0xFFF4E1C1);
        textColor = const Color(0xFF010101);
        backgroundColor = const Color(0xFFF8EBD5);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quran Surahs',
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle, // Apply the theme's appBar title style
        ),
      ),
      drawer: const MyDrawer(),
      backgroundColor: backgroundColor, // Apply the background color
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            color: cardColor, // Set the background color of the card
            child: Directionality(
              textDirection: TextDirection.rtl, // RTL text direction
              child: ListTile(
                title: Text(
                  surahs[index]['stitle'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'QuranNames', // Use Quran font for title
                    color: textColor, // Apply the text color based on the theme
                  ),
                ),
                subtitle: Text(
                  'آيات: ${surahs[index]['sAyah']} - | ${surahs[index]['sType']}',
                  style: TextStyle(
                    fontFamily: 'Quran', // Apply the Quran font to the subtitle
                    color: textColor, // Apply the text color based on the theme
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color:
                      textColor, // Ensure the icon color is consistent with the theme
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(surah: surahs[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
