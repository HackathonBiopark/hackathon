import 'package:flutter/material.dart';
import 'package:valides_app/ui/gemini.dart';

class TelaAvaliacaoArtigo extends StatefulWidget {
  final String titulo;

  const TelaAvaliacaoArtigo({super.key, this.titulo = 'Avaliação de Artigo'});

  @override
  State<TelaAvaliacaoArtigo> createState() => _TelaAvaliacaoArtigoState();
}

class _TelaAvaliacaoArtigoState extends State<TelaAvaliacaoArtigo> {
  List<Map<String, dynamic>> checklistPontos = [
    {'ponto': 'Erros de escrita', 'peso': 2, 'checked': false},
    {'ponto': 'Desvio do padrão ABNT', 'peso': 2, 'checked': false},
    {'ponto': 'Falta de referências', 'peso': 3, 'checked': false},
  ];

  bool isPdfVisible = false;
  String urlPDF =
      '/Users/davispecia/Documents/hackathon-main/art_hub/assets/img/FATURA AGATA 1701 A 1802 (1).pdf';

  final TextEditingController observacaoController = TextEditingController();
  String? geminiResponse;

  void _adicionarOuEditarPonto([int? index]) {
    final pontoController = TextEditingController();
    final pesoController = TextEditingController();

    if (index != null) {
      pontoController.text = checklistPontos[index]['ponto'];
      pesoController.text = checklistPontos[index]['peso'].toString();
    }
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
        title: Text(widget.titulo, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _adicionarOuEditarPonto(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text('Avaliar Artigo',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              const Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Título do artigo'),
                  subtitle: Text('Nome do autor'),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: const Text('Visualização do PDF'),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 1000, // Ajuste a largura conforme necessário
                  child: Image.asset(
                    'assets/img/pdf.png',
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.contain, // Ajuste a forma de preenchimento
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('Erro ao carregar imagem'),
                      );
                    },
                  ),
                ),
              ),
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
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        Text(geminiResponse!),
                      ],
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
      ),
    );
  }
}
