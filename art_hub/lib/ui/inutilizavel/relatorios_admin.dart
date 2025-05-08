import 'package:flutter/material.dart';

class RelatoriosAdminPage extends StatelessWidget {
  const RelatoriosAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK de dados (substituir por chamadas futuras à API)
    final int totalTarefas = 120;
    final int validadas = 90;
    final int faxineiras = 12;
    final int propriedades = 8;

    return Scaffold(
      appBar: AppBar(title: const Text("Relatórios")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            title: "Total de Tarefas",
            valor: "$totalTarefas",
            icon: Icons.assignment_outlined,
            color: Colors.blue,
          ),
          _buildCard(
            title: "Tarefas Validadas",
            valor: "$validadas",
            icon: Icons.verified_outlined,
            color: Colors.green,
          ),
          _buildCard(
            title: "Faxineiras Cadastradas",
            valor: "$faxineiras",
            icon: Icons.cleaning_services_outlined,
            color: Colors.orange,
          ),
          _buildCard(
            title: "Propriedades Ativas",
            valor: "$propriedades",
            icon: Icons.home_work_outlined,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String valor,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        trailing: Text(
          valor,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
