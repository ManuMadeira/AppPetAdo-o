import 'package:flutter/material.dart';
import 'pages/list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Pets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff4db6ac),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff4db6ac)),
        useMaterial3: true,
      ),
      home: const ListPage(),
    );
  }
}