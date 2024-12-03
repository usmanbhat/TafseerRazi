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

    // Theme-based colors
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
        backgroundColor = Colors.lightBlue;
        break;
      case AppTheme.CustomTheme:
      default:
        cardColor = const Color(0xFFF4E1C1);
        textColor = const Color(0xFF010101);
        backgroundColor = const Color(0xFFF8EBD5);
        break;
    }

    // Calculate columns dynamically
    int calculateColumns(double width) {
      if (width < 600) {
        return 1;
      } else if (width < 1200) {
        return 2;
      } else {
        return 3;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quran Surahs',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      drawer: const MyDrawer(),
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columnCount = calculateColumns(constraints.maxWidth);

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount, // Dynamically calculated columns
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
              childAspectRatio: constraints.maxWidth /
                  (columnCount * 100), // Adjust height dynamically
            ),
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rotated Number Container
                    Transform.rotate(
                      angle: 0.785398, // Rotate 45 degrees (PI/4 radians)
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Transform.rotate(
                          angle: -0.785398, // Rotate back 45 degrees
                          child: Center(
                            child: Text(
                              surahs[index]['sid'].toString(),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Title and Subtitle Section
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surahs[index]['sType'].toString(),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsScreen(surah: surahs[index]),
                          ),
                        );
                      },

                      // Arabic Name and Ayah Count
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            surahs[index]['stitle'].toString(),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            ' ${surahs[index]['sAyah']}.' '| آيات |',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
