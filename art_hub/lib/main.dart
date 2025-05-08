import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:valides_app/ui/gemini.dart';
import 'package:valides_app/ui/tela_home_autor.dart';
import 'package:valides_app/ui/tela_lista_artigos.dart';

import 'package:flutter/material.dart';

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
      ),
      home: const TelaHomeAutor(),
    );
  }
}
