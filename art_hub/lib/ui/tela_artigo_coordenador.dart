import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
  Map<String, dynamic> artigoDetalhado = {}; // Adicione esta linha
  String localPath = '';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

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
        artigoDetalhado = artigoEncontrado;
        localPath = artigoDetalhado['arquivo'];
      });

      if (artigoDetalhado['palavrasChave'] != null) {
        _carregarAvaliadores(artigoDetalhado['palavrasChave']);
      }
    }
  }

  Future<void> _carregarAvaliadores(List<dynamic> palavrasChave) async {
    try {
      final String response =
          await rootBundle.loadString('lib/conteudo/avaliadores.json');
      final List<dynamic> data = json.decode(response);

      final avaliadoresFiltrados = data.where((avaliador) {
        return palavrasChave
            .any((palavra) => avaliador['areaTematica'].contains(palavra));
      }).toList();

      if (avaliadoresFiltrados.isNotEmpty) {
        avaliadoresFiltrados.shuffle(Random());
        setState(() {
          avaliadoresSelecionados = avaliadoresFiltrados.take(3).toList();
        });
      }
    } catch (e) {
      print('Erro ao carregar os avaliadores: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarArtigo(widget.artigo['titulo']);
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
            const SizedBox(height: 16),

            // Card de Informações
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Autor(es)
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Autor(es): ${widget.artigo['autores'] ?? 'Desconhecido'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Tema
                    Row(
                      children: [
                        const Icon(Icons.book, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Tema: ${widget.artigo['areaTematica'] ?? 'Não especificado'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Palavras-chave
                    Row(
                      children: [
                        const Icon(Icons.label, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Palavras-chave: ${(widget.artigo['palavrasChave'] ?? []).join(', ')}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Resumo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.article, color: Colors.purple),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Resumo: ${widget.artigo['resumo'] ?? 'Resumo não disponível'}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Título da Seção de Avaliadores
            const Text(
              'Avaliadores Escolhidos:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D3E5F),
              ),
            ),
            const SizedBox(height: 8),

            // Lista de Avaliadores
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: avaliadoresSelecionados.length,
              itemBuilder: (context, index) {
                final avaliador = avaliadoresSelecionados[index];
                // Status do Avaliador (estático para demonstração)
                final bool jaAvaliou =
                    index % 2 == 0; // Alterna entre aprovado e pendente
                final String status = jaAvaliou ? 'Aprovado' : 'Pendente';
                final IconData statusIcon =
                    jaAvaliou ? Icons.check_circle : Icons.hourglass_empty;
                final Color statusColor =
                    jaAvaliou ? Colors.green : Colors.orange;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: Text(
                      '${avaliador['nome']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      '${avaliador['email']}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                              color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Arquivo em PDF:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            localPath.isNotEmpty
                ? Expanded(
                    child: SfPdfViewer.network(
                      localPath,
                      key: _pdfViewerKey,
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
