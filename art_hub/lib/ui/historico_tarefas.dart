import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoricoTarefasPage extends StatefulWidget {
  final String usuarioLogado;

  const HistoricoTarefasPage({super.key, required this.usuarioLogado});

  @override
  State<HistoricoTarefasPage> createState() => _HistoricoTarefasPageState();
}

class _HistoricoTarefasPageState extends State<HistoricoTarefasPage> {
  List<Map<String, dynamic>> tarefas = [];
  bool carregando = true;

  final String baseUrl =
      'alugaix.com.br/limpeza_app/backend/app.cgi'; // atualize com IP da API

  @override
  void initState() {
    super.initState();
    _buscarHistorico();
  }

  Future<void> _buscarHistorico() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?rota=historico?login=${widget.usuarioLogado}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          tarefas = data.cast<Map<String, dynamic>>();
          carregando = false;
        });
      } else {
        _mostrarErro("Erro ao carregar histórico");
      }
    } catch (e) {
      _mostrarErro("Erro de conexão: $e");
    }
  }

  void _mostrarErro(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erro"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Tarefas')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : tarefas.isEmpty
              ? const Center(child: Text('Nenhuma tarefa concluída.'))
              : ListView.builder(
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) {
                    final tarefa = tarefas[index];
                    final status = tarefa['status'] ?? 'indefinido';
                    final validado = tarefa['validado'] == true
                        ? '✅ Validado'
                        : '🕒 Aguardando';
                    final nome = tarefa['funcionaria'] ?? '---';
                    final apto = tarefa['apartamento'] ?? '---';

                    return Card(
                      child: ListTile(
                        title: Text("Apartamento $apto"),
                        subtitle: Text("Status: $status\nFuncionária: $nome"),
                        trailing: Text(validado),
                      ),
                    );
                  },
                ),
    );
  }
}
