import 'package:flutter/material.dart';

Color darkblue = const Color.fromRGBO(0, 48, 73, 1.0);
Color lightred = const Color.fromRGBO(193, 18, 31, 1.0);
Color darkred = const Color.fromRGBO(120, 0, 0, 1.0);
Color lightblue = const Color.fromRGBO(102, 155, 188, 1.0);
Color grey = const Color.fromARGB(255, 105, 105, 105);

void snackbarError(context, String errormessage, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errormessage),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );

TextStyle? labelTextStyle({required Color c, FontWeight? w, double? f}) {
  return TextStyle(
    color: c,
    fontWeight: w ?? FontWeight.w800,
    fontSize: f ?? 14,
    letterSpacing: 0.2,
  );
}

TextStyle? dataTextStyle({required Color c, FontWeight? w, double? f}) {
  return TextStyle(
    color: c,
    fontWeight: w ?? FontWeight.w400,
    fontSize: f ?? 18,
    letterSpacing: 0.3,
  );
}

Widget FilePageBody(
    String studyPlan, String title, double? bodyFontSize, Icon leadingIcon) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            leadingIcon,
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            SizedBox(
              width: 60,
              height: 60,
              child: IconButton(
                icon: const Icon(Icons.download_for_offline_rounded),
                color: grey, // Set the icon color
                onPressed: () {
                  // Define the action to be performed when the button is pressed
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Text(
                studyPlan,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: bodyFontSize,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
