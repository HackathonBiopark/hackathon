import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class TelaArtigoCoordenador extends StatefulWidget {
  final Map<String, dynamic> artigo;

  const TelaArtigoCoordenador({super.key, required this.artigo});

  @override
  State<TelaArtigoCoordenador> createState() => _TelaArtigoCoordenadorState();
}

class _TelaArtigoCoordenadorState extends State<TelaArtigoCoordenador> {
  List<dynamic> artigos = [];
  List<dynamic> avaliadores = [];
  List<dynamic> avaliadoresSelecionados = [];

  Future<void> _carregarArtigo(String titulo) async {
    final String response =
        await rootBundle.loadString('lib/conteudo/artigos.json');
    final List<dynamic> data = json.decode(response);

    final artigoEncontrado = data.firstWhere(
      (artigo) => artigo['titulo'] == titulo,
      orElse: () => null,
    );

    if (artigoEncontrado != null) {
      setState(() {
        widget.artigo.addAll(artigoEncontrado);
      });

      // Chama o carregamento dos avaliadores após obter o artigo
      _carregarAvaliadores(widget.artigo['areaTematica']);
    }
  }

  Future<void> _carregarAvaliadores(String areaTematica) async {
    final String response =
        await rootBundle.loadString('lib/conteudo/avaliadores.json');
    final List<dynamic> data = json.decode(response);

    final avaliadoresFiltrados = data
        .where((avaliador) => avaliador['areaTematica'] == areaTematica)
        .toList();

    if (avaliadoresFiltrados.isNotEmpty) {
      // Embaralha e seleciona 3 avaliadores aleatórios
      avaliadoresFiltrados.shuffle(Random());
      setState(() {
        avaliadoresSelecionados = avaliadoresFiltrados.take(3).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarArtigo(widget.artigo['titulo']);
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1D3E5F),
      child: ListView(
        children: [
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_rounded, color: Colors.white),
            title: const Text('Novo evento',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
              color: Colors.white30, thickness: 1, indent: 16, endIndent: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Eventos recentes',
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.artigo['titulo'] ?? 'Sem título',
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              widget.artigo['titulo'] ?? 'Título não disponível',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Autor(es): ${widget.artigo['autores'] ?? 'Desconhecido'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Tema: ${widget.artigo['areaTematica'] ?? 'Não especificado'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Palavras-chave: ${(widget.artigo['palavrasChave'] ?? []).join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Resumo: ${widget.artigo['resumo'] ?? 'Resumo não disponível'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Avaliadores escolhidos:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            for (var avaliador in avaliadoresSelecionados)
              Text(
                '${avaliador['nome']} - ${avaliador['email']}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),
            const Text(
              'Arquivo em PDF:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.artigo['arquivo'] ?? 'Arquivo não disponível',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
