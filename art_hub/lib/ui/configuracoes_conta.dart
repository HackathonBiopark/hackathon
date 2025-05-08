import 'package:flutter/material.dart';

class ConfiguracoesContaPage extends StatefulWidget {
  final String email;
  final String tipo;

  const ConfiguracoesContaPage({
    super.key,
    required this.email,
    required this.tipo,
  });

  @override
  State<ConfiguracoesContaPage> createState() => _ConfiguracoesContaPageState();
}

class _ConfiguracoesContaPageState extends State<ConfiguracoesContaPage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final novaSenha = _senhaController.text.trim();
      // TODO: atualizar senha no banco local/backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senha atualizada (mock).")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações da Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: const Text("Login (email)"),
                subtitle: Text(widget.email),
              ),
              ListTile(
                title: const Text("Tipo de conta"),
                subtitle: Text(widget.tipo),
              ),
              const SizedBox(height: 24),
              const Text("Alterar senha", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Nova senha",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "A senha deve ter no mínimo 6 caracteres";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text("Salvar Alterações"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
