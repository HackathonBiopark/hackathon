import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../configuracoes_conta.dart'; // tela de alterar senha e ver tipo de conta
import '../historico_tarefas.dart'; // histórico da faxineira ou gestor

class ProfileScreen extends StatelessWidget {
  final String nome;
  final String email;
  final String tipo; // 'admin', 'gerente_unidade', 'funcionario'

  const ProfileScreen({
    super.key,
    required this.nome,
    required this.email,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context); // ou deslogar
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),
          const Divider(),
          _buildListItem(Icons.checklist, 'Meu Histórico de Limpezas', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HistoricoTarefasPage(usuarioLogado: email),
              ),
            );
          }),
          _buildListItem(Icons.settings_outlined, 'Configurações da Conta', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ConfiguracoesContaPage(email: email, tipo: tipo),
              ),
            );
          }),
          _buildListItem(Icons.file_download_outlined, 'Exportar meus dados',
              () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Exportação simulada!")),
            );
          }),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Ajuda e Suporte',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          _buildListItem(FontAwesomeIcons.whatsapp, 'Falar com o suporte', () {
            // WhatsApp, chat ou email
          }, isFontAwesome: true),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ListTile(
      leading: const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black,
        child: Icon(Icons.person, color: Colors.white, size: 30),
      ),
      title: Text(nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      subtitle: Text(email),
      trailing: Text(
        tipo == 'admin'
            ? 'Administrador'
            : tipo == 'gerente_unidade'
                ? 'Gestor'
                : 'Faxineira',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, VoidCallback onTap,
      {bool isFontAwesome = false}) {
    return ListTile(
      leading: isFontAwesome
          ? FaIcon(icon, color: Colors.black)
          : Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
