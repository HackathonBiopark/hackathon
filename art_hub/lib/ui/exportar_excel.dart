import 'package:flutter/material.dart';

class ExportarExcelPage extends StatelessWidget {
  const ExportarExcelPage({super.key});

  void _simularExportacao(BuildContext context) {
    // TODO: Chamar o backend real futuramente com http.post

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("📁 Dados exportados para 'relatorio.xlsx' (simulação)."),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exportar Dados")),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_download, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                "Clique abaixo para exportar os dados das limpezas para Excel.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _simularExportacao(context),
                icon: const Icon(Icons.download),
                label: const Text("Exportar para Excel"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
