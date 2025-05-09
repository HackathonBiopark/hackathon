import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:valides_app/utils/avaliador.dart';

class DashboardSobrecarga extends StatefulWidget {
  const DashboardSobrecarga({Key? key}) : super(key: key);

  @override
  _DashboardSobrecargaState createState() => _DashboardSobrecargaState();
}

class _DashboardSobrecargaState extends State<DashboardSobrecarga> {
  late Future<List<Avaliador>> _futureAvaliadores;

  @override
  void initState() {
    super.initState();
    _futureAvaliadores = _carregarAvaliadores();
  }

  Future<List<Avaliador>> _carregarAvaliadores() async {
    final jsonString =
        await rootBundle.loadString('lib/conteudo/avaliadores.json');
    final List<dynamic> listaJson = json.decode(jsonString);
    return listaJson
        .map((item) => Avaliador.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard de Sobrecarga',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1D3E5F),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Avaliador>>(
        future: _futureAvaliadores,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final avaliadores = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: avaliadores.length,
            itemBuilder: (context, i) {
              final av = avaliadores[i];
              final pct = av.sobrecarga / 15;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        av.nome,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: pct,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        // opcional: muda de cor conforme nível
                        color: pct < 0.7
                            ? Colors.green
                            : pct < 1.0
                                ? Colors.orange
                                : Colors.red,
                      ),
                      const SizedBox(height: 6),
                      Text('${av.sobrecarga} / 15'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
