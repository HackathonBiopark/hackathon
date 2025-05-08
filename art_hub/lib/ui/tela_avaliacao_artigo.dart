import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TelaAvaliacaoArtigo extends StatefulWidget {
  final String titulo;

  const TelaAvaliacaoArtigo({super.key, this.titulo = 'Avaliação de Artigo'});

  @override
  State<TelaAvaliacaoArtigo> createState() => _TelaAvaliacaoArtigoState();
}

class _TelaAvaliacaoArtigoState extends State<TelaAvaliacaoArtigo> {
  List<Map<String, dynamic>> checklistPontos = [
    {'ponto': 'Ponto 1', 'peso': 1, 'checked': false},
    {'ponto': 'Ponto 2', 'peso': 2, 'checked': false},
    {'ponto': 'Ponto 3', 'peso': 3, 'checked': false},
  ];

  bool isPdfVisible = false;
  String urlPDF = '/Users/davispecia/Documents/hackathon-main/art_hub/assets/img/FATURA AGATA 1701 A 1802 (1).pdf';

  void _adicionarOuEditarPonto([int? index]) {
    final TextEditingController pontoController = TextEditingController();
    final TextEditingController pesoController = TextEditingController();

    if (index != null) {
      pontoController.text = checklistPontos[index]['ponto'];
      pesoController.text = checklistPontos[index]['peso'].toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Adicionar Ponto' : 'Editar Ponto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pontoController,
              decoration: const InputDecoration(labelText: 'Ponto'),
            ),
            TextField(
              controller: pesoController,
              decoration: const InputDecoration(labelText: 'Peso'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final novoPonto = {
                  'ponto': pontoController.text,
                  'peso': int.tryParse(pesoController.text) ?? 1,
                  'checked': false,
                };
                if (index == null) {
                  checklistPontos.add(novoPonto);
                } else {
                  checklistPontos[index] = novoPonto;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _alternarVisualizacaoPDF() {
    setState(() {
      isPdfVisible = !isPdfVisible;
    });
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1D3E5F),
      child: ListView(
        children: [
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Colors.white),
            title: const Text('Eventos disponíveis',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_rounded, color: Colors.white),
            title: const Text('Submissões', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
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
        title: Text(widget.titulo, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _adicionarOuEditarPonto(),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Avaliar Artigo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text('Título do artigo'),
                subtitle: const Text('Nome do autor'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(isPdfVisible ? 'Fechar PDF' : 'Abrir PDF'),
                onTap: _alternarVisualizacaoPDF,
              ),
            ),
            if (isPdfVisible)
              Expanded(
                child: SfPdfViewer.network(urlPDF),
              ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Checklist padrão',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...checklistPontos.asMap().entries.map((entry) {
                      int index = entry.key;
                      var ponto = entry.value;
                      return CheckboxListTile(
                        title: Text('${ponto['ponto']} (Peso: ${ponto['peso']})'),
                        value: ponto['checked'],
                        onChanged: (bool? value) {
                          setState(() {
                            checklistPontos[index]['checked'] = value ?? false;
                          });
                        },
                        secondary: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => _adicionarOuEditarPonto(index),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _adicionarOuEditarPonto(),
                      child: const Text('Adicionar Novo Ponto'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text('Nota:'),
                trailing: const Icon(Icons.edit, color: Colors.grey),
                onTap: () {
                  // Ação para editar nota
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
