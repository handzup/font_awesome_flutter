import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
 
void main() {
  runApp(FontAwesomeGalleryApp());
}

class FontAwesomeGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Awesome Flutter Gallery',
      theme: ThemeData.light().copyWith(
        iconTheme: IconThemeData(size: 36.0, color: Colors.black87),
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ),
      home: Container( color: Colors.white, child:  Center(child:Icon(  (FontAwesomeIcons.getIconString['light_abacus']  ))),)
    );
  }
}

 