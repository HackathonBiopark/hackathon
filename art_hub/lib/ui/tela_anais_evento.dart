import 'package:valides_app/ui/tela_adicao_evento.dart';
import 'package:valides_app/ui/tela_home_eventos.dart';
import 'package:flutter/material.dart';

class TelaAnaisEventos extends StatefulWidget {
  final String titulo;
  final String banner;

  const TelaAnaisEventos(
      {super.key, required this.titulo, required this.banner});

  @override
  State<TelaAnaisEventos> createState() => _TelaEventosState();
}

class _TelaEventosState extends State<TelaAnaisEventos> {
  final List<String> statusArtigos = List<String>.generate(10, (index) => '');
  final List<String> titulosEventos = [
    'Semana Acadêmica dos cursos de tecnologia - 2025',
    'Seminário de pesquisa',
  ];

  void _atualizarStatus(int index, String status) {
    setState(() {
      statusArtigos[index] = status;
    });
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
            leading: const Icon(Icons.add_rounded, color: Colors.white),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.titulo, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.banner,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anais de eventos disponíveis para visualização:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: titulosEventos.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(titulosEventos[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_browser),
                            onPressed: () {},
                          ),
                        ],
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
}
