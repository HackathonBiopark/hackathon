import 'package:flutter/material.dart';

class TelaHomeEventos extends StatelessWidget {
  final List<Map<String, String>> eventos = [
    {
      'titulo': 'Conferência Data Minds 2025',
      'banner': 'assets/img/fotoTecnologia.jpg',
    },
    {
      'titulo': 'Feira de Tecnologia IFPR',
      'banner': 'assets/img/fotoTecnologia.jpg',
    },
    {
      'titulo': 'Semana Acadêmica',
      'banner': 'assets/img/fotoTecnologia.jpg',
    },
    {
      'titulo': 'Workshop de IA',
      'banner': 'assets/img/fotoTecnologia.jpg',
    },
    {
      'titulo': 'Mostra de Projetos',
      'banner': 'assets/img/fotoTecnologia.jpg',
    },
    {
      'titulo': 'Hackathon IFPR',
      'banner': 'assets/img/fotoTecnologia.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        title: const Text('Eventos da Instituição',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
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
            return Card(
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
            );
          },
        ),
      ),
    );
  }
}
