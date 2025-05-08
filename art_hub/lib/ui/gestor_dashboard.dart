import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cadastro_propriedade.dart';
import 'listar_propriedades.dart';
import 'historico_tarefas.dart';
import 'ver_todas_limpezas.dart';
import 'cadastro_usuario.dart';
import 'validacao_limpeza_detalhada.dart';

class GestorDashboard extends StatefulWidget {
  const GestorDashboard({super.key});

  @override
  State<GestorDashboard> createState() => _GestorDashboardState();
}

class _GestorDashboardState extends State<GestorDashboard> {
  final String baseUrl = 'alugaix.com.br/limpeza_app/backend/app.cgi';
  List<Map<String, dynamic>> tarefas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTarefasPendentes();
  }

  Future<void> _carregarTarefasPendentes() async {
    setState(() => carregando = true);
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
        _mostrarErro(
            "Erro ao buscar limpezas (Status: ${response.statusCode})");
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
      appBar: AppBar(
        title: const Text('Painel do Gestor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDashboardCard(
            icon: Icons.home,
            title: 'Listar Propriedades',
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ListarPropriedadesPage()),
              );
            },
          ),
          _buildDashboardCard(
            icon: Icons.home_work,
            title: 'Cadastrar Propriedade',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CadastroPropriedadePage()),
              );
            },
          ),
          _buildDashboardCard(
            icon: Icons.person_add,
            title: 'Cadastrar Faxineira',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CadastroUsuarioPage()),
              );
            },
          ),
          _buildDashboardCard(
            icon: Icons.list_alt,
            title: 'Ver Todas as Limpezas',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VerTodasLimpezasPage()),
              );
            },
          ),
          _buildDashboardCard(
            icon: Icons.history,
            title: 'Histórico de Tarefas',
            color: Colors.brown,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const HistoricoTarefasPage(usuarioLogado: 'gestor'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Validação de Limpezas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          carregando
              ? const Center(child: CircularProgressIndicator())
              : tarefas.isEmpty
                  ? const Center(child: Text("Sem tarefas para validar"))
                  : Column(
                      children: tarefas.map((tarefa) {
                        final ap = tarefa["apartamento"] ?? "???";
                        final nome = tarefa["funcionario"] ?? '---';
                        final data = tarefa["data_limpeza"] ?? '---';
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text("Apartamento $ap"),
                            subtitle: Text("Faxineira: $nome\nData: $data"),
                            trailing: ElevatedButton(
                              child: const Text("Ver Detalhes"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ValidarLimpezasPage(tarefa: tarefa),
                                  ),
                                ).then((_) => _carregarTarefasPendentes());
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    )
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
