import 'package:alugaix_app/ui/telas/autenticacao/forgot_password.dart';
import 'package:alugaix_app/ui/telas/autenticacao/login.dart';
import 'package:flutter/material.dart';

import 'ui/homescreen.dart';
import 'ui/cadastro_usuario.dart';
import 'ui/cadastro_propriedade.dart';
import 'ui/listar_propriedades.dart';
import 'ui/admin_dashboard.dart';
import 'ui/gestor_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de artigos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const CadastroUsuarioPage(),
        '/homescreen': (context) => const HomeScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/cadastro-propriedade': (context) => const CadastroPropriedadePage(),
        '/listar-propriedades': (context) => const ListarPropriedadesPage(),
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/gestor-dashboard': (context) => const GestorDashboard(),
      },
    );
  }
}
