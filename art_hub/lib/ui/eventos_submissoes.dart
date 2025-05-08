import 'package:flutter/material.dart';
import 'package:valides_app/ui/tela_submissao_autor.dart';

class TelaEnvioEvento extends StatefulWidget {
  const TelaEnvioEvento({super.key});

  @override
  State<TelaEnvioEvento> createState() => _TelaEnvioEventoState();
}

class _TelaEnvioEventoState extends State<TelaEnvioEvento> {
  final String tituloEvento = 'Encontro Regional de Tecnologia';
  final String descricaoEvento =
      'Um evento que promove a troca de conhecimentos sobre inovação e tecnologia.';
  final String dataEvento = '15 de Junho de 2025';
  final String bannerEvento = 'assets/img/fotoTecnologia.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Painel do Autor',
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
        child: _buildCardEvento(
          imagem: bannerEvento,
          titulo: tituloEvento,
          descricao: descricaoEvento,
          data: dataEvento,
        ),
      ),
    );
  }

  Widget _buildCardEvento({
    required String imagem,
    required String titulo,
    required String descricao,
    required String data,
  }) {
    return SizedBox(
      height: 300,
      width: 350,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(titulo),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Descrição: $descricao'),
                    const SizedBox(height: 8),
                    Text('Data: $data'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Fechar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaSubmissaoAutor(),
                        ),
                      );
                    },
                    child: const Text('Submeter Artigo'),
                  ),
                ],
              ),
            );
          },
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
}
