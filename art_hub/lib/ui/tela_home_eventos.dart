import 'package:alugaix_app/ui/tela_adicao_evento.dart';
import 'package:alugaix_app/ui/tela_evento.dart';
import 'package:flutter/material.dart';

class TelaHomeEventos extends StatefulWidget {
  const TelaHomeEventos({super.key});

  @override
  State<TelaHomeEventos> createState() => _TelaHomeEventosState();
}

class _TelaHomeEventosState extends State<TelaHomeEventos> {
  final List<Map<String, String>> eventos = [
    {
      'titulo': 'Conferência Data Minds 2025',
      'banner': 'assets/img/fotoTecnologia.jpg'
    },
  ];

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
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
          itemCount: eventos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final evento = eventos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TelaEvento(
                            titulo: 'Conferência Data Minds 2025',
                            banner: 'assets/img/fotoTecnologia.jpg',
                          )),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(
                        evento['banner']!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        evento['titulo']!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TelaHomeEventos()),
              );
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
