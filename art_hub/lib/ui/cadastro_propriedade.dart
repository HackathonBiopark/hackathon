import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroPropriedadePage extends StatefulWidget {
  const CadastroPropriedadePage({super.key});

  @override
  State<CadastroPropriedadePage> createState() =>
      _CadastroPropriedadePageState();
}

class _CadastroPropriedadePageState extends State<CadastroPropriedadePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  final String baseUrl =
      'alugaix.com.br/limpeza_app/backend/app.cgi'; // Corrigido para 5050 (não 5000)

  Future<void> _cadastrarPropriedade() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse('$baseUrl?rota=propriedades'), // Corrigido aqui 👈
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': _nomeController.text.trim(),
        'endereco': _enderecoController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      _mostrarAlerta('Propriedade cadastrada com sucesso!', sucesso: true);
      _nomeController.clear();
      _enderecoController.clear();
    } else {
      _mostrarAlerta(data['mensagem'] ?? 'Erro ao cadastrar propriedade',
          sucesso: false);
    }
  }

  void _mostrarAlerta(String mensagem, {required bool sucesso}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(sucesso ? 'Sucesso' : 'Erro'),
        content: Text(mensagem),
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
      appBar: AppBar(title: const Text('Cadastro de Propriedade')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Propriedade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe o endereço'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _cadastrarPropriedade,
                child: const Text('Cadastrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
