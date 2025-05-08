import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListarPropriedadesPage extends StatefulWidget {
  const ListarPropriedadesPage({super.key});

  @override
  State<ListarPropriedadesPage> createState() => _ListarPropriedadesPageState();
}

class _ListarPropriedadesPageState extends State<ListarPropriedadesPage> {
  final String baseUrl =
      'alugaix.com.br/limpeza_app/backend/app.cgi'; // IP e porta corretos
  Map<String, dynamic> propriedades = {};
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarPropriedades();
  }

  Future<void> _buscarPropriedades() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?rota=propriedades'));
      print("📡 RESPOSTA: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          propriedades = Map<String, dynamic>.from(data);
          carregando = false;
        });
      } else {
        _mostrarErro(
            "Erro ao carregar propriedades. Código ${response.statusCode}");
      }
    } catch (e) {
      _mostrarErro("Falha de conexão: $e");
    }
  }

  void _mostrarErro(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erro"),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Propriedades")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : propriedades.isEmpty
              ? const Center(child: Text("Nenhuma propriedade cadastrada."))
              : ListView.builder(
                  itemCount: propriedades.length,
                  itemBuilder: (_, index) {
                    final nome = propriedades.keys.elementAt(index);
                    final dados = propriedades[nome];
                    final endereco =
                        dados['endereco'] ?? 'Endereço não informado';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.apartment),
                        title: Text(nome),
                        subtitle: Text(endereco),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: ação futura
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
