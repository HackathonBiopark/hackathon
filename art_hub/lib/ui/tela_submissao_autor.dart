import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TelaSubmissaoAutor extends StatefulWidget {
  const TelaSubmissaoAutor({super.key});

  @override
  State<TelaSubmissaoAutor> createState() => _TelaSubmissaoAutorState();
}

class _TelaSubmissaoAutorState extends State<TelaSubmissaoAutor> {
  String? bannerFileName;
  String? selectedArea;

  final List<String> _areasTematicas = [
    'Comunicação',
    'Cultura',
    'Direitos humanos e justiça',
    'Educação',
    'Meio Ambiente',
    'Saúde',
    'Tecnologia e Produção',
    'Trabalho'
  ];

  void _pickBannerFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        bannerFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        title:
            const Text('Nova submissão', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Título',
                          hintText: 'Digite o nome do artigo',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Autores',
                          hintText: 'Informe os autores',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Resumo',
                          hintText: 'Insira o resumo (até 2000 caracteres)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Palavras-chave',
                          hintText: 'Coloque até 5 palavras-chave',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Área temática',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedArea,
                        items: _areasTematicas.map((area) {
                          return DropdownMenuItem(
                            value: area,
                            child: Text(area),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedArea = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickBannerFile,
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Arquivo em PDF com metadados',
                              prefixIcon: const Icon(Icons.attach_file),
                              hintText:
                                  bannerFileName ?? 'Selecionar arquivo PDF',
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickBannerFile,
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Arquivo em PDF sem metadados',
                              prefixIcon: const Icon(Icons.attach_file),
                              hintText:
                                  bannerFileName ?? 'Selecionar arquivo PDF',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D3E5F),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Enviar para análise',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
