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
    setState(
      () {
        statusArtigos[index] = status;
      },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "../assets/img/anais_evento.jpg",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
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
