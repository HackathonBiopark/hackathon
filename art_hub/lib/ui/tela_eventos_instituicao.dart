import 'package:valides_app/ui/tela_evento_coordenador.dart';
import 'package:valides_app/ui/tela_evento_autor.dart'; // Nova tela de autor

import 'package:flutter/material.dart';
import '../utils/user_preferences.dart'; // Import para pegar o tipo de usuário

class TelaHomeEventos extends StatefulWidget {
  const TelaHomeEventos({super.key});

  @override
  State<TelaHomeEventos> createState() => _TelaHomeEventosState();
}

class _TelaHomeEventosState extends State<TelaHomeEventos> {
  String userType = '';

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Future<void> _getUserType() async {
    final tipo = await UserPreferences.getUserType();
    setState(() {
      userType = tipo ?? 'Autor'; // Padrão: Autor
    });
  }

  final List<Map<String, String>> eventos = [
    {
      'titulo': 'Conferência Data Minds 2025',
      'banner': '../assets/img/fotoTecnologia1.jpg'
    },
    {
      'titulo': 'Simpósio de Inovação Tecnológica',
      'banner': '../assets/img/fotoTecnologia.jpg'
    },
  ];

  void _navegarParaTelaEvento(String titulo, String banner) {
    if (userType == 'Coordenador' || userType == 'Administrador') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaEventoCoordenador(
            titulo: titulo,
            banner: banner,
          ),
        ),
      );
    } else if (userType == 'Autor') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaEventoAutor(
            titulo: titulo,
            banner: banner,
            artigoTitulo: 'Aplicações da IA na Educação',
            artigoResumo: 'Este artigo explora o impacto da IA no ensino...',
            statusArtigo: 'Pendente',
          ),
        ),
      );
    }
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
            return GestureDetector(
              onTap: () => _navegarParaTelaEvento(
                evento['titulo']!,
                evento['banner']!,
              ),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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
}
