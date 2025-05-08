import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TarefaDetalhePage extends StatefulWidget {
  final Map<String, dynamic> tarefa;

  const TarefaDetalhePage({super.key, required this.tarefa});

  @override
  State<TarefaDetalhePage> createState() => _TarefaDetalhePageState();
}

class _TarefaDetalhePageState extends State<TarefaDetalhePage> {
  final List<String> checklistItems = [
    'Varreu o chão',
    'Limpou banheiro',
    'Trocou lençóis',
    'Desinfetou superfícies',
  ];
  final Map<String, bool> checklistStatus = {};
  final List<File> fotos = [];

  bool emExecucao = false;
  DateTime? inicioLimpeza;

  @override
  void initState() {
    super.initState();
    for (var item in checklistItems) {
      checklistStatus[item] = false;
    }
  }

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.camera);

    if (imagem != null) {
      setState(() {
        fotos.add(File(imagem.path));
      });
    }
  }

  void _iniciarLimpeza() {
    setState(() {
      emExecucao = true;
      inicioLimpeza = DateTime.now();
    });
  }

  void _finalizarTarefa() {
    final fim = DateTime.now();

    final dados = {
      "apartamento": widget.tarefa["apartamento"],
      "inicio": inicioLimpeza?.toIso8601String(),
      "fim": fim.toIso8601String(),
      "checklist": checklistStatus,
      "fotos": fotos.map((f) => f.path).toList(),
    };

    print('Enviar para backend: $dados');

    // TODO: enviar dados via POST para o backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tarefa enviada para validação!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ap = widget.tarefa["apartamento"];

    return Scaffold(
      appBar: AppBar(title: Text('Limpeza Apto $ap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Status: ${widget.tarefa["status"]}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            if (!emExecucao)
              ElevatedButton(
                onPressed: _iniciarLimpeza,
                child: const Text("Iniciar Limpeza"),
              ),
            if (emExecucao) ...[
              const Text('Checklist:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...checklistItems.map((item) => CheckboxListTile(
                    title: Text(item),
                    value: checklistStatus[item],
                    onChanged: (val) => setState(() => checklistStatus[item] = val ?? false),
                  )),
              const SizedBox(height: 16),
              const Text('Fotos da Limpeza:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: fotos.map((f) => Image.file(f, width: 100, height: 100, fit: BoxFit.cover)).toList(),
              ),
              ElevatedButton.icon(
                onPressed: _selecionarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Anexar Foto"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _finalizarTarefa,
                child: const Text("Finalizar e Enviar"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
