import 'package:flutter/material.dart';

class EditarPropriedadePage extends StatefulWidget {
  final String nomeAtual;
  final String enderecoAtual;

  const EditarPropriedadePage({
    super.key,
    required this.nomeAtual,
    required this.enderecoAtual,
  });

  @override
  State<EditarPropriedadePage> createState() => _EditarPropriedadePageState();
}

class _EditarPropriedadePageState extends State<EditarPropriedadePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _enderecoController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeAtual);
    _enderecoController = TextEditingController(text: widget.enderecoAtual);
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final novoNome = _nomeController.text.trim();
      final novoEndereco = _enderecoController.text.trim();

      // TODO: Enviar para o backend futuramente
      print("📝 Propriedade atualizada:");
      print("Nome: $novoNome");
      print("Endereço: $novoEndereco");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alterações salvas (mock).")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Propriedade")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome da Propriedade",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o nome" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o endereço" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text("Salvar Alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
