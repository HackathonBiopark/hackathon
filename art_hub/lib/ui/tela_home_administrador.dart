import 'package:flutter/material.dart';
import 'package:valides_app/ui/tela_adicao_evento.dart' show TelaAdicaoEvento;
import 'package:valides_app/ui/tela_anais_evento.dart';
import 'package:valides_app/ui/tela_evento_coordenador.dart';
import 'package:valides_app/ui/tela_eventos_instituicao.dart';
import 'package:valides_app/ui/tela_login.dart';

class TelaHomeAdministrador extends StatefulWidget {
  const TelaHomeAdministrador({super.key});

  @override
  State<TelaHomeAdministrador> createState() => _TelaHomeAdministradorState();
}

class _TelaHomeAdministradorState extends State<TelaHomeAdministrador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Eventos da Instituição',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(200.0),
        child: Row(
          children: [
            Expanded(
              child: _buildCardEvento(
                imagem: '../assets/img/imagem_aberta.jpg',
                titulo: 'Inscrições abertas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaEventoCoordenador(
                        titulo: 'Inscrições abertas',
                        banner: '../assets/img/fotoTecnologia2.jpg',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildCardEvento(
                imagem: '../assets/img/dash.jpg',
                titulo: 'Dashbord dos avaliadores',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaAnaisEventos(
                        titulo: 'Dashbord dos avaliadores',
                        banner: "../assets/img/dash.jpg",
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildCardEvento(
                imagem: '../assets/img/imagem_finalizado.jpg',
                titulo: 'Eventos finalizados',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaAnaisEventos(
                        titulo: 'Anais de evento',
                        banner: "../assets/img/fotoTecnologia2.jpg",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardEvento({
    required String imagem,
    required String titulo,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: 250,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  imagem,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1D3E5F),
      child: ListView(
        children: [
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.white),
            title: const Text('Novo evento',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TelaAdicaoEvento()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
            title: const Text('Sair', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
              );
            },
          ),
          const Divider(
              color: Colors.white30, thickness: 1, indent: 16, endIndent: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Eventos recentes',
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ),
          const ListTile(
            dense: true,
            title: Text(
              'Conferência Data Minds 2025',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            leading: Icon(Icons.event_note, color: Colors.white70, size: 20),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}
