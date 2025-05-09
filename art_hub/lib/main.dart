import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/material.dart';
import 'package:valides_app/ui/inicio/tela_login.dart';

void main() {
  Gemini.init(
    apiKey: "AIzaSyCskKL-4epujI_JwiaNUgJ7p7Ss9a9ZmWc",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const TelaLogin(),
    );
  }
}
