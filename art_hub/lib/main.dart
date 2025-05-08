import 'package:valides_app/ui/tela_avaliacao_artigo.dart';
import 'package:valides_app/ui/tela_home.dart';
import 'package:valides_app/ui/tela_home_autor.dart';
import 'package:valides_app/ui/tela_home_avaliador.dart';
import 'package:valides_app/ui/tela_home_eventos.dart';
import 'package:valides_app/ui/tela_lista_artigos.dart';
import 'package:valides_app/ui/tela_login.dart';

import 'package:flutter/material.dart';

void main() {
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
