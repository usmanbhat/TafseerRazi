import 'package:flutter/material.dart';

class StyledTextWithBraces extends StatelessWidget {
  final String text;
  final double textSize;
  final String fontFamily;

  const StyledTextWithBraces({
    Key? key,
    required this.text,
    required this.textSize,
    required this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final regex = RegExp(r'\{(.*?)\}');
    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    Color textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    regex.allMatches(text).forEach((match) {
      // Add plain text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
            fontSize: textSize,
            fontFamily: fontFamily,
            color: textColor,
          ),
        ));
      }

      // Add the styled text inside braces
      spans.add(TextSpan(
        text: match.group(1), // Get the content inside the braces
        style: TextStyle(
          color: Colors.blue,
          fontSize: textSize.toDouble(),
          fontFamily: 'Quran', // Custom font for braces
        ),
      ));

      lastMatchEnd = match.end;
    });

    // Add any remaining plain text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
          fontSize: textSize,
          fontFamily: fontFamily,
          color: textColor,
        ),
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.start,
    );
  }
}
