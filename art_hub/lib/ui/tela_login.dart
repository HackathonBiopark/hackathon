import 'package:valides_app/ui/tela_home_administrador.dart';
import 'package:valides_app/ui/tela_home_autor.dart';
import 'package:valides_app/ui/tela_home_avaliador.dart';
import 'package:flutter/material.dart';
import '../utils/user_preferences.dart';

void main() {
  runApp(const TelaLogin());
}

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  final _passwordController = TextEditingController();

  final List<String> _roles = ['Administrador', 'Autor', 'Avaliador'];

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Salvar o tipo de usuário globalmente
      await UserPreferences.saveUserType(_selectedRole!);

      // Navegar para a tela correspondente
      if (_selectedRole == 'Administrador') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaHomeAdministrador()),
        );
      } else if (_selectedRole == 'Autor') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaHomeAutor()),
        );
      } else if (_selectedRole == 'Avaliador') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaHomeAvaliador()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 5, 36, 87),
              Color.fromARGB(255, 10, 62, 138),
              Color.fromARGB(255, 20, 108, 200),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 232, 229),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(175, 85, 136, 168),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      '../../assets/img/LOGO9.png',
                      filterQuality: FilterQuality.high,
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedRole,
                      items: _roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione uma função' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == 'admin' ? null : 'Senha incorreta',
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D3E5F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Entrar",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
