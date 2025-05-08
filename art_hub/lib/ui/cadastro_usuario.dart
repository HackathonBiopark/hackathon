import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key});

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _tipoSelecionado = 'funcionario';

  final String baseUrl =
      'alugaix.com.br/limpeza_app/backend/app.cgi'; // Corrigido para 5050!

  Future<void> _cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse('$baseUrl?rota=usuarios'), // Corrigido aqui
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': _nomeController.text.trim(),
        'login': _loginController.text.trim(),
        'senha': _senhaController.text.trim(),
        'tipo': _tipoSelecionado,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      _mostrarAlerta('Usuário cadastrado com sucesso!', sucesso: true);
      _formKey.currentState?.reset();
      _nomeController.clear();
      _loginController.clear();
      _senhaController.clear();
      setState(() => _tipoSelecionado = 'funcionario'); // volta para padrão
    } else {
      _mostrarAlerta(data['mensagem'] ?? 'Erro ao cadastrar usuário',
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
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o login' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) => v == null || v.length < 6
                    ? 'Senha mínima de 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                onChanged: (val) => setState(() => _tipoSelecionado = val!),
                decoration: const InputDecoration(
                  labelText: 'Tipo de Usuário',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'funcionario', child: Text('Faxineira')),
                  DropdownMenuItem(
                      value: 'gerente_unidade', child: Text('Gestor')),
                  DropdownMenuItem(
                      value: 'admin', child: Text('Administrador')),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _cadastrarUsuario,
                child: const Text('Cadastrar Usuário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
