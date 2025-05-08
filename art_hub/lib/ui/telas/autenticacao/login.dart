import 'package:alugaix_app/ui/admin_dashboard.dart';
import 'package:alugaix_app/ui/gestor_dashboard.dart';
import 'package:alugaix_app/ui/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String tipoSelecionado = 'funcionario'; // tipo padrão

  String baseUrl = 'alugaix.com.br/limpeza_app/backend/app.cgi';

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl?rota=login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': _loginController.text.trim(),
          'senha': _senhaController.text.trim(),
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tipo = data['usuario']['tipo'] ?? tipoSelecionado;

        _redirecionarPorTipo(tipo);
      } else {
        final msg =
            jsonDecode(response.body)['mensagem'] ?? 'Erro ao fazer login';
        _mostrarErro(msg);
      }
    } catch (e) {
      _mostrarErro('Erro de conexão: $e');
    }
  }

  void _redirecionarPorTipo(String tipo) {
    Widget nextPage;

    if (tipo == 'admin') {
      nextPage = const AdminDashboard();
    } else if (tipo == 'gestor') {
      nextPage = const GestorDashboard();
    } else {
      nextPage = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro'),
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
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite o login' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite a senha' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Usuário (teste)',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'admin', child: Text('Administrador')),
                  DropdownMenuItem(value: 'gestor', child: Text('Gestor')),
                  DropdownMenuItem(
                      value: 'funcionario', child: Text('Faxineira')),
                ],
                onChanged: (value) => setState(() {
                  tipoSelecionado = value!;
                }),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _fazerLogin,
                      child: const Text('Entrar'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Criar uma conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
