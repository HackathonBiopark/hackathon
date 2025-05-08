import 'package:flutter/material.dart';
import 'tela_avaliacao_artigo.dart';

class TelaListaArtigos extends StatefulWidget {
  const TelaListaArtigos({super.key});

  @override
  State<TelaListaArtigos> createState() => _TelaListaArtigosState();
}

class _TelaListaArtigosState extends State<TelaListaArtigos> {
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1D3E5F),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.white),
            title: const Text('Eventos disponíveis',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_rounded, color: Colors.white),
            title:
                const Text('Submissões', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
        title: const Text('Avaliador', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Artigos para Avaliação',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Número de artigos (pode ser dinâmico)
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                        _abrirAvaliacaoArtigo('Título do artigo $index'),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: const Color.fromARGB(255, 220, 219, 219),
                      child: ListTile(
                        title: Text(
                          'Título do artigo $index',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Nome do autor',
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
