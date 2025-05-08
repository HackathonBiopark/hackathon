import 'package:flutter/material.dart';
import 'dart:io';

class TarefaDetalhadaViewPage extends StatelessWidget {
  final Map<String, dynamic> tarefa;

  const TarefaDetalhadaViewPage({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    final checklist = Map<String, dynamic>.from(tarefa['checklist'] ?? {});
    final fotos = List<String>.from(tarefa['fotos'] ?? []);
    final status = tarefa['status'] ?? 'Indefinido';
    final validado =
        tarefa['validado'] == true ? '✅ Validado' : '🕒 Aguardando';
    final obs = tarefa['observacoes'] ?? 'Sem observações';

    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes da Limpeza")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildInfo("Apartamento", tarefa['apartamento']),
            _buildInfo("Funcionária", tarefa['funcionaria']),
            _buildInfo("Data da Limpeza", tarefa['data_limpeza']),
            _buildInfo("Status", status),
            _buildInfo("Validação", validado),
            const SizedBox(height: 20),
            const Text("Checklist Realizado:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...checklist.entries.map((e) => ListTile(
                  title: Text(e.key),
                  leading: Icon(e.value
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                )),
            const SizedBox(height: 20),
            const Text("Observações:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(obs),
            const SizedBox(height: 20),
            const Text("Fotos da Limpeza:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            fotos.isEmpty
                ? const Text("Nenhuma foto anexada.")
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fotos.map((path) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Image.file(File(path), fit: BoxFit.cover),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String titulo, dynamic valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$titulo: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(valor?.toString() ?? "---"),
        ],
      ),
    );
  }
}
