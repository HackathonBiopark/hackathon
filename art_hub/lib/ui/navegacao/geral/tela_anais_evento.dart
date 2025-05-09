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
  final List<Map<String, dynamic>> eventos = [
    {
      'titulo':
          'Inteligência Artificial Aplicada à Detecção de Ciberataques em Redes 5G: Uma Abordagem Baseada em Deep Learning',
      'area': 'Tecnologia',
      'autores': 'Tainá Dreissig e Luiz Feltrin',
      'imagem': '../assets/img/fotoTecnologia.jpg'
    },
    {
      'titulo':
          'Os Impactos da Globalização na Identidade Cultural: Um Estudo Etnográfico em Comunidades Tradicionais no Nordeste Brasileiro',
      'area': 'Ciências Humanas',
      'autores': 'Jonathan Margraf e Vinicius Carraro',
      'imagem': '../assets/img/fotoTecnologia1.jpg'
    },
    {
      'titulo':
          'Análise de Eficiência Energética em Sistemas de Refrigeração Industrial Utilizando Troca de Calor com Nanofluidos',
      'area': 'Engenharia',
      'autores': 'Samuel Alves e Davi Specia',
      'imagem': '../assets/img/fotoTecnologia2.jpg'
    },
  ];

  String _searchTerm = '';
  String _selectedFilter = 'Todos';

  List<Map<String, dynamic>> get filteredEventos {
    if (_searchTerm.isEmpty) return eventos;

    return eventos.where((evento) {
      if (_selectedFilter == 'Área') {
        return evento['area'].toLowerCase().contains(_searchTerm.toLowerCase());
      } else if (_selectedFilter == 'Autores') {
        return evento['autores']
            .toLowerCase()
            .contains(_searchTerm.toLowerCase());
      } else {
        return evento['titulo']
                .toLowerCase()
                .contains(_searchTerm.toLowerCase()) ||
            evento['area'].toLowerCase().contains(_searchTerm.toLowerCase()) ||
            evento['autores'].toLowerCase().contains(_searchTerm.toLowerCase());
      }
    }).toList();
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
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar anais...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchTerm = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilterChip(
                          label: const Text('Todos'),
                          selected: _selectedFilter == 'Todos',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = 'Todos';
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('Área'),
                          selected: _selectedFilter == 'Área',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = 'Área';
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('Autores'),
                          selected: _selectedFilter == 'Autores',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = 'Autores';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Text(
              'Anais de eventos disponíveis para visualização:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredEventos.isEmpty
                  ? const Center(
                      child: Text('Nenhum evento encontrado'),
                    )
                  : ListView.builder(
                      itemCount: filteredEventos.length,
                      itemBuilder: (context, index) {
                        final evento = filteredEventos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                evento['imagem'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(evento['titulo']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Área: ${evento['area']}'),
                                Text('Autores: ${evento['autores']}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_browser),
                              onPressed: () {},
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
