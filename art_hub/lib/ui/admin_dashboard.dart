import 'package:flutter/material.dart';

import 'cadastro_propriedade.dart';
import '../listar_propriedades.dart';
import '../historico_tarefas.dart';
import 'inutilizavel/relatorios_admin.dart';
import '../ver_todas_limpezas.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context); // volta para login
            },
          )
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
            icon: Icons.analytics,
            title: 'Relatórios',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RelatoriosAdminPage(),
                ),
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
                  builder: (_) => HistoricoTarefasPage(usuarioLogado: 'admin'),
                ),
              );
            },
          ),
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
