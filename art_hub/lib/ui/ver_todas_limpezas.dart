import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerTodasLimpezasPage extends StatefulWidget {
  const VerTodasLimpezasPage({super.key});

  @override
  State<VerTodasLimpezasPage> createState() => _VerTodasLimpezasPageState();
}

class _VerTodasLimpezasPageState extends State<VerTodasLimpezasPage> {
  final String baseUrl = 'alugaix.com.br/limpeza_app/backend/app.cgi';
  Map<String, dynamic> limpezas = {};
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLimpezas();
  }

  Future<void> _carregarLimpezas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?rota=limpezas'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          limpezas = Map<String, dynamic>.from(data);
          carregando = false;
        });
      } else {
        _mostrarErro('Erro ${response.statusCode} ao carregar limpezas');
      }
    } catch (e) {
      _mostrarErro('Falha de conexão: $e');
    }
  }

  void _mostrarErro(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todas as Limpezas')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : limpezas.isEmpty
              ? const Center(child: Text("Nenhuma limpeza registrada."))
              : ListView(
                  padding: const EdgeInsets.all(8),
                  children: limpezas.entries.map((entry) {
                    final apto = entry.key;
                    final info = entry.value;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Apto $apto - ${info['status']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Funcionária: ${info['funcionaria'] ?? "Não atribuída"}'),
                            Text('Saída: ${info['data_saida'] ?? "N/A"}'),
                            Text('Limpeza: ${info['data_limpeza'] ?? "N/A"}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
