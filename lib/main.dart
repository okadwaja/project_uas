import 'package:flutter/material.dart';
import 'package:project_uas/screen/recent_book_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DBooks App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RecentBooksScreen(),
    );
  }
}
