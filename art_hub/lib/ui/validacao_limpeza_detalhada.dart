import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidarLimpezasPage extends StatefulWidget {
  const ValidarLimpezasPage({super.key, required Map<String, dynamic> tarefa});

  @override
  State<ValidarLimpezasPage> createState() => _ValidarLimpezasPageState();
}

class _ValidarLimpezasPageState extends State<ValidarLimpezasPage> {
  final String baseUrl =
      'alugaix.com.br/limpeza_app/backend/app.cgi'; // Atualize para o IP da sua API
  List<Map<String, dynamic>> tarefas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTarefasPendentes();
  }

  Future<void> _carregarTarefasPendentes() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl?rota=limpezas-para-validar'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tarefas = List<Map<String, dynamic>>.from(data);
          carregando = false;
        });
      } else {
        _mostrarErro("Erro ao buscar limpezas");
      }
    } catch (e) {
      _mostrarErro("Erro de conexão: $e");
    }
  }

  Future<void> _validarTarefa(String ap) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?rota=limpezas/$ap/validar'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Limpeza do ap. $ap validada')),
        );
        setState(() {
          tarefas.removeWhere((t) => t["apartamento"] == ap);
        });
      } else {
        _mostrarErro("Falha ao validar tarefa");
      }
    } catch (e) {
      _mostrarErro("Erro de conexão: $e");
    }
  }

  Future<void> _recusarTarefa(String ap) async {
    final TextEditingController motivoController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Motivo da recusa"),
        content: TextField(
          controller: motivoController,
          decoration: const InputDecoration(hintText: "Digite o motivo"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              final motivo = motivoController.text.trim();
              if (motivo.isEmpty) return;

              try {
                final response = await http.post(
                  Uri.parse('$baseUrl?rota=limpezas/$ap/reprovar'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({"motivo": motivo}),
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Limpeza do ap. $ap recusada')),
                  );
                  setState(() {
                    tarefas.removeWhere((t) => t["apartamento"] == ap);
                  });
                } else {
                  _mostrarErro("Erro ao recusar");
                }
              } catch (e) {
                _mostrarErro("Erro de conexão: $e");
              }

              Navigator.pop(context);
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
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
      appBar: AppBar(
        title: const Text('Validação de Limpezas'),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : tarefas.isEmpty
              ? const Center(child: Text("Sem tarefas para validar"))
              : ListView.builder(
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) {
                    final tarefa = tarefas[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("Apartamento ${tarefa["apartamento"]}"),
                        subtitle: Text(
                            "Faxineira: ${tarefa["funcionario"] ?? '---'}\nData: ${tarefa["data_limpeza"] ?? ''}"),
                        trailing: Wrap(
                          spacing: 10,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                              onPressed: () =>
                                  _validarTarefa(tarefa["apartamento"]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () =>
                                  _recusarTarefa(tarefa["apartamento"]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
