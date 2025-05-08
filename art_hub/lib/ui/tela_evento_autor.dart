import 'package:valides_app/ui/tela_home_eventos.dart';

import 'package:flutter/material.dart';

class TelaEventoAutor extends StatefulWidget {
  final String titulo;
  final String banner;
  final String artigoTitulo;
  final String artigoResumo;
  final String statusArtigo;

  const TelaEventoAutor({
    super.key,
    required this.titulo,
    required this.banner,
    required this.artigoTitulo,
    required this.artigoResumo,
    required this.statusArtigo,
  });

  @override
  State<TelaEventoAutor> createState() => _TelaEventoAutorState();
}

class _TelaEventoAutorState extends State<TelaEventoAutor> {
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
          const Divider(
            color: Colors.white30,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Eventos Recentes',
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
            // Banner do Evento
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

            // Título do Evento
            Text(
              widget.titulo,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3E5F),
              ),
            ),
            const SizedBox(height: 16),

            // Seção do Artigo do Autor
            const Text(
              'Meu Artigo:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D3E5F),
              ),
            ),
            const SizedBox(height: 8),

            // Card com Detalhes do Artigo
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título do Artigo
                    Text(
                      widget.artigoTitulo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Resumo do Artigo
                    Text(
                      widget.artigoResumo,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status do Artigo
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Status: ${widget.statusArtigo}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.statusArtigo == 'Aprovado'
                                ? Colors.green
                                : widget.statusArtigo == 'Recusado'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Botão para Detalhes
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Ação ao clicar no botão de detalhes
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Detalhes do Artigo'),
                              content: Text(
                                'Título: ${widget.artigoTitulo}\n\nResumo: ${widget.artigoResumo}\n\nStatus: ${widget.statusArtigo}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Fechar'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D3E5F),
                        ),
                        child: const Text('Ver Detalhes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
