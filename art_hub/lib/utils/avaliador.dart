import 'dart:math';

class Avaliador {
  final String nome;
  final int sobrecarga; // 0 a 15

  Avaliador({required this.nome, required this.sobrecarga});

  factory Avaliador.fromJson(Map<String, dynamic> json) {
    // adapta o campo conforme seu arquivo JSON
    final nomeField = json['nome'] ?? json['name'] ?? '—';
    // gera um valor aleatório de sobrecarga para fins visuais
    final rnd = Random();
    return Avaliador(
      nome: nomeField,
      sobrecarga: rnd.nextInt(16), // 0..15
    );
  }
}
