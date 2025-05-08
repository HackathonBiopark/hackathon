import 'package:flutter/material.dart';
import 'tarefa_detalhe.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Limpezas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: implementar logout real
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: const FaxineiraTarefasWidget(),
    );
  }
}

class FaxineiraTarefasWidget extends StatefulWidget {
  const FaxineiraTarefasWidget({super.key});

  @override
  State<FaxineiraTarefasWidget> createState() => _FaxineiraTarefasWidgetState();
}

class _FaxineiraTarefasWidgetState extends State<FaxineiraTarefasWidget> {
  List<Map<String, dynamic>> tarefas = []; // mock por enquanto
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    // TODO: Fazer chamada ao backend para listar tarefas dessa funcionária logada
    await Future.delayed(const Duration(seconds: 1)); // simula carregamento

    setState(() {
      tarefas = [
        {
          "apartamento": "A101",
          "status": "pendente",
          "data_saida": "2025-04-21 10:30",
        },
        {
          "apartamento": "B203",
          "status": "em_andamento",
          "data_saida": "2025-04-20 12:00",
        },
      ];
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) return const Center(child: CircularProgressIndicator());

    if (tarefas.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa atribuída.'));
    }

    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        return Card(
          child: ListTile(
            title: Text('Apartamento ${tarefa["apartamento"]}'),
            subtitle: Text(
                'Status: ${tarefa["status"]} | Saída: ${tarefa["data_saida"]}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TarefaDetalhePage(tarefa: tarefa),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
