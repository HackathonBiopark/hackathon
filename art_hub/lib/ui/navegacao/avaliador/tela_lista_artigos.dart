import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'tela_avaliacao_artigo.dart';

class TelaListaArtigos extends StatefulWidget {
  const TelaListaArtigos({super.key});

  @override
  State<TelaListaArtigos> createState() => _TelaListaArtigosState();
}

class _TelaListaArtigosState extends State<TelaListaArtigos> {
  List<dynamic> artigos = [];

  @override
  void initState() {
    super.initState();
    _carregarArtigos();
  }

  Future<void> _carregarArtigos() async {
    try {
      final String response =
          await rootBundle.loadString('lib/conteudo/artigos.json');
      setState(() {
        artigos = json.decode(response);
      });
    } catch (e) {
      print('Erro ao carregar artigos: $e');
    }
  }

  void _abrirAvaliacaoArtigo(String titulo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaAvaliacaoArtigo(titulo: titulo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Artigos para Avaliação',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: artigos.length,
                itemBuilder: (context, index) {
                  final artigo = artigos[index];
                  return GestureDetector(
                    onTap: () => _abrirAvaliacaoArtigo(artigo['titulo']),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          artigo['titulo'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Nome do autor indisponível',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
