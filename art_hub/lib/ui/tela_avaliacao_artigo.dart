import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:valides_app/ui/gemini.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TelaAvaliacaoArtigo extends StatefulWidget {
  final String titulo;

  const TelaAvaliacaoArtigo({super.key, required this.titulo});

  @override
  State<TelaAvaliacaoArtigo> createState() => _TelaAvaliacaoArtigoState();
}

class _TelaAvaliacaoArtigoState extends State<TelaAvaliacaoArtigo> {
  List<Map<String, dynamic>> checklistPontos = [
    {'ponto': 'Erros de escrita', 'peso': 0.2, 'checked': false},
    {'ponto': 'Desvio do padrão ABNT', 'peso': 0.5, 'checked': false},
    {'ponto': 'Falta de referências', 'peso': 0.2, 'checked': false},
  ];

  bool isPdfVisible = false;

  final TextEditingController observacaoController = TextEditingController();
  final TextEditingController notaController = TextEditingController();

  String? geminiResponse;

  void _adicionarOuEditarPonto([int? index]) {
    final pontoController = TextEditingController();
    final pesoController = TextEditingController();

    if (index != null) {
      pontoController.text = checklistPontos[index]['ponto'];
      pesoController.text = checklistPontos[index]['peso'].toString();
    }
  }

  void _alternarVisualizacaoPDF() {
    setState(() => isPdfVisible = !isPdfVisible);
  }

  Future<void> _enviarParaGemini() async {
    final errosSelecionados = checklistPontos
        .where((e) => e['checked'] == true)
        .map((e) => e['ponto'].toString())
        .toList();

    setState(() => geminiResponse = 'Aguarde, gerando resposta...');
    final resposta =
        await fazerTextoGemini(errosSelecionados, observacaoController.text);
    setState(() => geminiResponse = resposta ?? 'Erro ao obter resposta');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text("Avaliar Artigo", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(widget.titulo),
                  subtitle: const Text('Nome do autor indisponível'),
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
                SizedBox(
                    height: 1000,
                    width: 1000,
                    child: PdfViewer.openFutureFile(
                      () async => (await DefaultCacheManager().getSingleFile(
                              'https://github.com/HackathonBiopark/hackathon/blob/9f2a46d38794459fe949ebfbc49b86b772e46942/art_hub/assets/pdf/artigo1.pdf'))
                          .path,
                      onError: (err) => print(err),
                      params: const PdfViewerParams(
                        padding: 10,
                        minScale: 1.0,
                      ),
                    )),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Checklist padrão',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...checklistPontos.asMap().entries.map((entry) {
                        final index = entry.key;
                        final ponto = entry.value;
                        return CheckboxListTile(
                          title: Text(
                              '${ponto['ponto']} (Peso: ${ponto['peso']})'),
                          value: ponto['checked'],
                          onChanged: (value) {
                            setState(() => checklistPontos[index]['checked'] =
                                value ?? false);
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
                      const SizedBox(height: 8),
                      const Text('Observação',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: observacaoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descreva a situação',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _enviarParaGemini,
                        child: const Text('Gerar Sugestões'),
                      ),
                      if (geminiResponse != null) ...[
                        const SizedBox(height: 12),
                        const Text('Resposta do Gemini:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        SelectableText(
                          geminiResponse!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Devolutiva Final',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a devolutiva final',
                        ),
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Prazo para atender aos pareceres dos avaliadores',
                  hintText: 'dd/mm/aaaa',
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    'Nota: ${notaController.text}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.grey),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController novaNotaController =
                            TextEditingController(text: notaController.text);
                        return AlertDialog(
                          title: const Text('Editar Nota'),
                          content: TextField(
                            controller: novaNotaController,
                            decoration: const InputDecoration(
                              labelText: 'Digite a nova nota',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  notaController.text = novaNotaController.text;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Salvar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D3E5F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Salvar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
