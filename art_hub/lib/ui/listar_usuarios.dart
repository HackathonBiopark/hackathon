import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListarUsuariosPage extends StatefulWidget {
  const ListarUsuariosPage({super.key});

  @override
  State<ListarUsuariosPage> createState() => _ListarUsuariosPageState();
}

class _ListarUsuariosPageState extends State<ListarUsuariosPage> {
  final String baseUrl =
      'alugaix.com.br/limpeza_app/backend/app.cgi'; // atualize com seu IP

  Map<String, dynamic> usuarios = {};
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarUsuarios();
  }

  Future<void> _buscarUsuarios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?rota=usuarios'));
      if (response.statusCode == 200) {
        setState(() {
          usuarios = jsonDecode(response.body);
          carregando = false;
        });
      } else {
        _mostrarErro("Erro ao carregar usuários");
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
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuários Cadastrados")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
              ? const Center(child: Text("Nenhum usuário cadastrado."))
              : ListView(
                  children: usuarios.entries.map((entry) {
                    final user = entry.value;
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(user['nome']),
                        subtitle: Text("Login: ${user['login']}"),
                        trailing: Text(
                          user['tipo'],
                          style: TextStyle(
                            color: user['tipo'] == 'admin'
                                ? Colors.red
                                : user['tipo'] == 'gerente_unidade'
                                    ? Colors.blue
                                    : Colors.green,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
