import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "!اسلام عليكم \n Mohammad Usman Bhat",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "A passionate full-stack developer and Android app developer from Kashmir. "
              "I love creating intuitive web and mobile applications.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _launchURL('https://portfolio-mohammad.web.app/'),
              child: const Text('View My Portfolio'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedin),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () => _launchURL(
                      'https://www.linkedin.com/in/mohammad-usman-bhat-75779716b/'),
                  tooltip: 'LinkedIn',
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.github),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () => _launchURL('https://github.com/Usman-bhat'),
                  tooltip: 'GitHub',
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.twitter),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () =>
                      _launchURL('https://twitter.com/m_usmanbhat'),
                  tooltip: 'Twitter/X',
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL(
                  'https://play.google.com/apps/publish/?account=7820612022916724487'), // Replace with actual Play Store URL
              child: const Text('Visit My Play Store Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
