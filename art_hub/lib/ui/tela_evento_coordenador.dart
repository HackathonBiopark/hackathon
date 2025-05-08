import 'package:valides_app/ui/tela_artigo_coordenador.dart';
import 'package:flutter/material.dart';

class TelaEventoCoordenador extends StatefulWidget {
  final String titulo;
  final String banner;

  const TelaEventoCoordenador(
      {super.key, required this.titulo, required this.banner});

  @override
  State<TelaEventoCoordenador> createState() => _TelaEventoState();
}

class _TelaEventoState extends State<TelaEventoCoordenador> {
  final List<String> statusArtigos = List<String>.generate(10, (index) => '');
  final List<String> titulosArtigos = [
    'Aplicações da IA na Educação: Desafios e Oportunidades',
    'O Impacto da Transformação Digital nas Instituições de Ensino',
    'Gestão de Eventos Acadêmicos com Tecnologia de Automação',
  ];

  void _atualizarStatus(int index, String status) {
    setState(() {
      statusArtigos[index] = status;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprovado':
        return const Color.fromARGB(255, 56, 142, 60);
      case 'Reprovado':
        return const Color.fromARGB(255, 211, 47, 47);
      case 'Revisões necessárias':
        return const Color.fromARGB(255, 41, 98, 255);
      case 'Em avaliação':
        return const Color.fromARGB(255, 175, 76, 157);
      default:
        return Colors.grey;
    }
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
              'Artigos Recebidos:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: titulosArtigos.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(titulosArtigos[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.turned_in,
                                color: Color.fromARGB(255, 175, 76, 157)),
                            onPressed: () {
                              _atualizarStatus(index, 'Avaliação');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle,
                                color: Color.fromARGB(255, 54, 244, 79)),
                            onPressed: () {
                              _atualizarStatus(index, 'Aprovado');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              _atualizarStatus(index, 'Reprovado');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color.fromARGB(255, 54, 105, 244)),
                            onPressed: () {
                              _atualizarStatus(index, 'Revisões');
                            },
                          ),
                        ],
                      ),
                      subtitle: Text(
                        statusArtigos[index],
                        style: TextStyle(
                          color: _getStatusColor(statusArtigos[index]),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaArtigoCoordenador(
                              artigo: {
                                'titulo': titulosArtigos[index],
                                'autores': 'Indisponível',
                                'resumo': 'Resumo do artigo...'
                              },
                            ),
                          ),
                        );
                      },
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
